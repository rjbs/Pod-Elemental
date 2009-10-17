package Pod::Elemental::Element::Pod5::Region;
use Moose;
with qw(
  Pod::Elemental::Paragraph
  Pod::Elemental::Node
  Pod::Elemental::FormatRegion
  Pod::Elemental::Command
);

use Moose::Autobox;

sub command         { 'begin' }
sub closing_command { 'end' }

sub as_pod_string {
  my ($self) = @_;

  my $content = $self->content;

  my $colon = $self->is_pod ? ':' : '';

  my $string = sprintf "=%s %s%s\n",
    $self->command,
    $colon . $self->format_name,
    ($content =~ /\S/ ? " $content" : "");

  $string .= $self->children->map(sub { $_->as_pod_string })->join(q{});

  $string .= sprintf "=%s %s\n\n",
    $self->closing_command,
    $colon . $self->format_name;

  return $string;
}

sub as_debug_string { $_[0]->as_pod_string }

no Moose;
1;
