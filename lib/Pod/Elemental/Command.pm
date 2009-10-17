package Pod::Elemental::Command;
use Moose::Role;
with 'Pod::Elemental::Paragraph' => { excludes => [ 'as_pod_string' ] };
# ABSTRACT: a =command paragraph

use Moose::Autobox;

requires 'command';

sub as_pod_string {
  my ($self) = @_;

  my $content = $self->content;

  sprintf "=%s%s", $self->command, ($content =~ /\S/ ? " $content" : "\n");
}

sub as_debug_string {
  my ($self) = @_;
  return sprintf '=%s', $self->command;
}

1;
