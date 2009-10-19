package Pod::Elemental::Element::Generic::Command;
use Moose;
# ABSTRACT: a POD =command element

use namespace::autoclean;

use Moose::Autobox;

sub type { 'command' }

=attr command

This attribute contains the name of the command, like C<head1> or C<encoding>.

=cut

has command => (
  is  => 'rw',
  isa => 'Str',
  required => 1,
);

with 'Pod::Elemental::Command';

1;
