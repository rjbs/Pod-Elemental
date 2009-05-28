package Pod::Elemental::Nester;
use Moose::Role;
use Moose::Autobox;
# ABSTRACT: something that organizes a sequence of elements into a tree

use namespace::autoclean;

use Pod::Elemental::Element;
use Pod::Elemental::Element::Command;

requires 'nest_elements'

=method nest_elements

  $nester->nest_elements(\@elements);

This method reorganizes the given elements into a tree.  It returns the same
reference it was given, which will have been reorganized in place.

Some elements, like C<=cut> commands, may be dropped.

=cut

1;
