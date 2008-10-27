package Pod::Elemental::Document;
use Moose;
with 'Pod::Elemental::Role::Children';
# ABSTRACT: a pod document

use Moose::Autobox;
use Moose::Util::TypeConstraints;

use Pod::Elemental::Element::Data;

=attr target

This is the format to which the document was targeted.  By default, this is
undefined and the document is vanilla pod.  If this is set, the document may or
may not be pod, and is intended for some other form of processor.  (See
L</is_pod>.)

=cut

subtype 'TargetStr'
  => as 'Str'
  => where { length $_ and /\A\S+\z/ };

has target => (is => 'ro', isa => 'Maybe[TargetStr]', default => undef);

=attr is_pod

If true, this document contains pod paragraphs, as opposed to data paragraphs.
This will generally result from the document originating in a C<=begin> block
with a colon-prefixed target identifier:

  =begin :html

    This is still a verbatim paragraph.

  =end :html

=cut

has is_pod => (is => 'ro', isa => 'Bool', required => 1, default => 1);

=attr encoding

This attribute, if set, indicates the encoding of the document.

=cut

has encoding => (is => 'rw', isa => 'Maybe[Str]');

=method target_string

This returns the target to be included in the pod output.  It is the C<target>
attribute, if set, prepended with a colon if C<is_pod> is true.

=cut

sub target_string {
  my ($self) = @_;
  return undef unless defined $self->target;
  return sprintf '%s%s', ($self->is_pod ? ':' : ''), $self->target;
}

sub _parse_forbegin_target {
  my ($self, $str) = @_;

  my %attr;
  my ($colon, $target, $content) = $str=~ m/
    \A
    (:)?
    (\S+)
    (?:\s+(.+))?
    \z
  /x;

  return {
    is_pod => ($colon ? 1 : 0),
    target => $target,
    (defined $content ? (content => $content) : ()),
  };
}

sub _from_for_element {
  my ($self, $element) = @_;

  my $attr = $self->_parse_forbegin_target($element->content);

  my $doc = Pod::Elemental::Document->new({
    is_pod => $attr->{is_pod},
    target => $attr->{target},
  });

  $doc->add_elements([
    Pod::Elemental::Element::Text->new({
      type    => 'text',
      content => $attr->{content},
    }),
  ]);
}

sub _from_begin_element {
  my ($self, $element) = @_;

  my $attr = $self->_parse_forbegin_target($element->content);

  my $doc = Pod::Elemental::Document->new({
    is_pod => $attr->{is_pod},
    target => $attr->{target},
  });

  $doc->add_elements(scalar $element->children);

  return $doc;
}

sub _xform_elements {
  my ($self, $elements) = @_;

  my @new_elements;

  ELEMENT: for my $element ($elements->flatten) {
    if ($element->type eq 'command') {
      if ($element->command eq 'for') {
        $element = $self->_from_for_element($element);
      } elsif ($element->command eq 'begin') {
        $element = $self->_from_begin_element($element);
      } elsif ($element->command eq 'encoding') {
        if (defined $self->encoding and $self->encoding ne $element->content) {
          confess "found two conflicting encodings";
        }
        $self->encoding( $element->content );
        next ELEMENT;
      } else {
        $self->_xform_elements( scalar $element->children );
      }
    }

    if (
      ! $self->is_pod
      and $element->isa('Pod::Elemental::Element')
      and $element->type eq [qw(text verbatim)]->any
    ) {
      $element = Pod::Elemental::Element::Data->new({
        content => $element->content,
      });
    }

    if (
      $element->isa('Pod::Elemental::Document')
      and defined $element->encoding
    ) {
      if (defined $self->encoding and $self->encoding ne $element->encoding) {
        confess "found two conflicting encodings";
      } elsif (not defined $self->encoding) {
        $self->encoding( $element->encoding );
      }
    }

    @new_elements->push($element);
  }

  @$elements = @new_elements;
}

sub add_elements {
  my ($self, $elements) = @_;

  $self->_xform_elements($elements);

  $self->children->push(@$elements);
}

sub command {
  my ($self) = @_;
  return 'pod' unless defined $self->target;
  return 'begin';
}

sub as_hash {
  my ($self) = @_;

  my $hash = {
    target  => $self->target,
    is_pod  => $self->is_pod ? 1 : 0,
  };

  $hash->{children} = $self->children->map(sub { $_->as_hash })
    if $self->children->length;

  return $hash;
}

sub as_string {
  my ($self) = @_;

  my @para;

  if ($self->command eq 'pod') {
    push @para, "=pod\n";
  } else {
    push @para, sprintf "=%s %s\n", $self->command, $self->target_string;
  }

  if ($self->children->length) {
    push @para, $self->children->map(sub { $_->as_string })->flatten;
  }

  if ($self->command eq 'pod') {
    push @para, "=cut\n";
  } else {
    push @para, '=end ' . $self->target_string . "\n";
  }

  return join "\n", @para;
}

sub as_debug_string {
  my ($self) = @_;
  return $self->as_string; # XXX: obviously this sucks -- rjbs, 2008-10-26
}

sub BUILD {
  my ($self) = @_;

  confess "document must be pod if no target is supplied"
    if ! $self->is_pod and ! defined $self->target;
}

__PACKAGE__->meta->make_immutable;
no Moose;
no Moose::Util::TypeConstraints;
1;
