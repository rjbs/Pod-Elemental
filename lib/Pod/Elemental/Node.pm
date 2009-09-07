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
L<Pod::Elemental::Node|Pod::Elemental::Node>-doing objects, and represents
elements contained by an object.

=cut

has children => (
  is   => 'rw',
  isa  => ArrayRef[ role_type('Pod::Elemental::Paragraph') ],
  required   => 1,
  default    => sub { [] },
);

1;
