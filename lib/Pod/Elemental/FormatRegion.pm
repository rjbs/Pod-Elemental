package Pod::Elemental::FormatRegion;
use Moose::Role;
with 'Pod::Elemental::Region';

use Moose::Autobox;

use Pod::Elemental::Types qw(FormatName);
use MooseX::Types::Moose qw(Bool);

=attr format_name

This is the format to which the document was targeted.  By default, this is
undefined and the document is vanilla pod.  If this is set, the document may or
may not be pod, and is intended for some other form of processor.  (See
L</is_pod>.)

=cut

has format_name => (is => 'ro', isa => FormatName, required => 1);

=attr is_pod

If true, this document contains pod paragraphs, as opposed to data paragraphs.
This will generally result from the document originating in a C<=begin> block
with a colon-prefixed target identifier:

  =begin :html

    This is still a verbatim paragraph.

  =end :html

=cut

has is_pod => (is => 'ro', isa => Bool, required => 1, default => 1);

sub _parse_region_marker {
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

sub command {
  my ($self) = @_;
  return 'pod' unless defined $self->target;
  return 'begin';
}

1;
