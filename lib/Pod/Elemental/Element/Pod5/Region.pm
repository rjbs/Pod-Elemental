package Pod::Elemental::Element::Pod5::Region;
# ABSTRACT: a region of Pod (this role likely to be removed)

use Moose;
with qw(
  Pod::Elemental::Paragraph
  Pod::Elemental::Node
  Pod::Elemental::Command
);

=head1 WARNING

This class is somewhat sketchy and may be refactored somewhat in the future,
specifically to refactor its similarities to
L<Pod::Elemental::Element::Nested>.

=head1 OVERVIEW

A Pod5::Region element represents a region marked by a C<=for> command or a
pair of C<=begin> and C<=end> commands.  It may have content of its own as well
as child paragraphs.

Its C<as_pod_string> method will emit either a C<=begin/=end>-enclosed string
or a C<=for> command, based on whichever is permissible.

=cut

use Moose::Autobox;

use Pod::Elemental::Types qw(FormatName);
use MooseX::Types::Moose qw(Bool);

=attr format_name

This is the format to which the region was targeted.  

B<Note!>  The format name should I<not> include the leading colon to indicate a
pod paragraph.  For that, see C<L</is_pod>>.

=cut

has format_name => (is => 'ro', isa => FormatName, required => 1);

=attr is_pod

If true, this region contains pod (ordinary or verbatim) paragraphs, as opposed
to data paragraphs.  This will generally result from the document originating
in a C<=begin> block with a colon-prefixed target identifier:

  =begin :html

    This is still a verbatim paragraph.

  =end :html

=cut

has is_pod => (is => 'ro', isa => Bool, required => 1, default => 1);

sub command         { 'begin' }
sub closing_command { 'end' }

sub _display_as_for {
  my ($self) = @_;

  # Everything after "=for target" becomes the lone child paragraph, so there
  # is nowhere to put the (technically illegal) content. -- rjbs, 2009-11-24
  return if $self->content =~ /\S/;

  # We can't have more than one paragraph, because there'd be a blank, so we
  # couldn't round trip. -- rjbs, 2009-11-24
  return if $self->children->length != 1;

  my $child = $self->children->[0];

  return if $child->content =~ m{^\s*$}m;

  my $base = 'Pod::Elemental::Element::Pod5::';
  return 1 if   $self->is_pod and $child->isa("${base}Ordinary");
  return 1 if ! $self->is_pod and $child->isa("${base}Data");

  return;
}

sub as_pod_string {
  my ($self) = @_;

  my $string;

  if ($self->_display_as_for) {
    $string = $self->__as_pod_string_for($self);
  } else {
    $string = $self->__as_pod_string_begin($self);
  }

  $string =~ s/\n*\z//g;

  return $string;
}

sub __as_pod_string_begin {
  my ($self) = @_;

  my $content = $self->content;
  my $colon   = $self->is_pod ? ':' : '';

  my $string = sprintf "=%s %s%s\n",
    $self->command,
    $colon . $self->format_name,
    ($content =~ /\S/ ? " $content\n" : "\n");

  $string .= $self->children->map(sub { $_->as_pod_string })->join(q{});

  $string .= "\n\n"
    if  $self->children->length
    and $self->children->[-1]->isa( 'Pod::Elemental::Element::Pod5::Data');
    # Pod5::$self->is_pod; # XXX: HACK!! -- rjbs, 2009-10-21

  $string .= sprintf "=%s %s",
    $self->closing_command,
    $colon . $self->format_name;

  return $string;
}

sub __as_pod_string_for {
  my ($self) = @_;

  my $content = $self->content;
  my $colon = $self->is_pod ? ':' : '';

  my $string = sprintf "=for %s %s",
    $colon . $self->format_name,
    $self->children->[0]->as_pod_string;

  return $string;
}

sub as_debug_string {
  my ($self) = @_;

  my $colon = $self->is_pod ? ':' : '';

  my $string = sprintf "=%s %s",
    $self->command,
    $colon . $self->format_name;

  return $string;
}

with 'Pod::Elemental::Autoblank';
with 'Pod::Elemental::Autochomp';

# BEGIN Autochomp Replacement
use Pod::Elemental::Types qw(ChompedString);
has '+content' => (coerce => 1, isa => ChompedString);
# END   Autochomp Replacement

__PACKAGE__->meta->make_immutable;
no Moose;
1;
