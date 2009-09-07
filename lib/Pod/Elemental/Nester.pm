package Pod::Elemental::Transformer;
use Moose::Role;
use Moose::Autobox;
# ABSTRACT: something that transforms a document tree into a new tree

use namespace::autoclean;

use Pod::Elemental::Element;
use Pod::Elemental::Element::Command;

requires 'transform_document';

=method transform_document

  my $document = $nester->transform_document($document);

This method must produce a new Document based on the input Document.

=cut

1;
