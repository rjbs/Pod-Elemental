package Pod::Elemental::Element::Command;
use Moose;
extends 'Pod::Elemental::Element';
with 'Pod::Elemental::Role::Children';
# ABSTRACT: a POD =command element

use Moose::Autobox;

has '+type' => (default => 'command');

=attr command

This attribute contains the name of the command, like C<head1> or C<encoding>.

=cut

has command => (is => 'ro', isa => 'Str', required => 0);

sub as_hash {
  my ($self) = @_;

  my $hash = {
    type    => $self->type,
    content => $self->content,
    command => $self->command,
  };

  $hash->{children} = $self->children->map(sub { $_->as_hash })
    if $self->children->length;

  return $hash;
}

sub as_string {
  my ($self) = @_;

  my @para;

  push @para, sprintf "=%s %s\n", $self->command, $self->content;
  if ($self->children->length) {
    push @para, $self->children->map(sub { $_->as_string })->flatten;
  }

  push @para, "=back\n" if $self->command eq 'over';
  push @para, ('=end ' . $self->content . "\n") if $self->command eq 'begin';

  return join "\n", @para;
}

sub as_debug_string {
  my ($self) = @_;

  my @para;

  push @para, sprintf "=%s %s\n", $self->command, $self->content;
  if ($self->children->length) {
    my @sub = $self->children->map(sub { $_->as_debug_string })->flatten;
    s/^/  /gm for @sub;
    push @para, @sub;
  }

  push @para, "=back\n" if $self->command eq 'over';
  push @para, ('=end ' . $self->content . "\n") if $self->command eq 'begin';

  return join "", @para;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
