package Pod::Elemental::Element::Command;
use Moose;
with 'Pod::Elemental::Command';
# ABSTRACT: a POD =command element

use namespace::autoclean;

use Moose::Autobox;

sub type { 'command' }

=attr command

This attribute contains the name of the command, like C<head1> or C<encoding>.

=cut

has command => (
  is  => 'ro',
  isa => 'Str',
  required => 1,
);

1;
