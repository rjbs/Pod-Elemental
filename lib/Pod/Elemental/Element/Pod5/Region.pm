package Pod::Elemental::Element::Pod5::Region;
# ABSTRACT: a region of Pod (this role likely to be removed)
use Moose;
with qw(
  Pod::Elemental::Paragraph
  Pod::Elemental::Node
  Pod::Elemental::Command
);

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

sub command         { 'begin' }
sub closing_command { 'end' }

sub _display_as_for {
  my ($self) = @_;

  return if $self->content =~ /\S/;
  return if $self->children->length != 1;

  my $child = $self->children->[0];

  my $base = 'Pod::Elemental::Element::Pod5::';
  return 1 if   $self->is_pod and $child->isa("${base}Data");
  return 1 if ! $self->is_pod and $child->isa("${base}Ordinary");

  return;
}

sub as_pod_string {
  my ($self) = @_;

  if ($self->_display_as_for) {
    return $self->__as_pod_string_for($self);
  } else {
    return $self->__as_pod_string_begin($self);
  }
}

sub __as_pod_string_begin {
  my ($self) = @_;

  my $content = $self->content;
  my $colon = $self->is_pod ? ':' : '';

  my $string = sprintf "=%s %s%s\n",
    $self->command,
    $colon . $self->format_name,
    ($content =~ /\S/ ? " $content" : "\n");

  $string .= $self->children->map(sub { $_->as_pod_string })->join(q{});

  $string .= sprintf "=%s %s\n",
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
    $self->children->map(sub { $_->as_pod_string })->join(q{});

  chomp $string;

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

no Moose;
1;
