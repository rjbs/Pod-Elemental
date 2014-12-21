package Pod::Elemental::Transformer;
# ABSTRACT: something that transforms a node tree into a new tree

use Moose::Role;

use namespace::autoclean;

requires 'transform_node';

=head1 OVERVIEW

Pod::Elemental::Transformer is a role to be composed by anything that takes a
node and messes around with its contents.  This includes transformers to
implement Pod dialects, Pod tree nesting strategies, and Pod document
rewriters.

A class including this role must implement the following methods:

=method transform_node

  my $node = $nester->transform_node($node);

This method alters the given node and returns it.  Apart from that, the sky is
the limit.

=cut

1;
