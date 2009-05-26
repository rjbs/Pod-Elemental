package Pod::Elemental::Node;
use Moose::Role;
# ABSTRACT: a thing with Pod::Elemental::Nodes as children

use namespace::autoclean;

use Moose::Autobox;
use MooseX::Types;
use MooseX::Types::Moose qw(ArrayRef);
use Moose::Util::TypeConstraints qw(class_type);

requires 'as_pod_string';
requires 'as_debug_string';

=attr children

This attribute is an arrayref of
L<Pod::Elemental::Element|Pod::Elemental::Element> objects, and represents
elements contained by an object.

=cut

has children => (
  is   => 'rw',
  isa  => ArrayRef[ role_type('Pod::Elemental::Element') ],
  auto_deref => 1,
  required   => 1,
  default    => sub { [] },
);

no Moose::Role;
1;
