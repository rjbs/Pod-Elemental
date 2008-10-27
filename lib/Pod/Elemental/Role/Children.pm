package Pod::Elemental::Role::Children;
use Moose::Role;
# ABSTRACT: a thing with Pod::Elemental::Elements as children

use Moose::Autobox;

=attr children

This attribute is an arrayref of
L<Pod::Elemental::Element|Pod::Elemental::Element> objects, and represents
elements contained by an object.

=cut

has children => (
  is   => 'rw',
  isa  => 'ArrayRef[Pod::Elemental::Element]',
  auto_deref => 1,
  required   => 1,
  default    => sub { [] },
);

no Moose::Role;
1;
