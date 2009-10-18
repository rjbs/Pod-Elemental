package Pod::Elemental::Transformer;
use Moose::Role;
use Moose::Autobox;
# ABSTRACT: something that transforms a node tree into a new tree

use namespace::autoclean;

requires 'transform_node';

=method transform_node

  my $node = $nester->transform_node($node);

This method alters the given node and returns it.

=cut

1;
