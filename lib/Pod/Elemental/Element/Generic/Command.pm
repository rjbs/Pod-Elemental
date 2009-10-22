package Pod::Elemental::Element::Generic::Command;
use Moose;
# ABSTRACT: a Pod =command element

use namespace::autoclean;

use Moose::Autobox;

=head1 OVERVIEW

Generic::Command elements are paragraph elements implementing the
Pod::Elemental::Command role.  They provide the command method by implementing
a read/write command attribute.

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
