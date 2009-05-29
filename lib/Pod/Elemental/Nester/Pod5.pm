package Pod::Elemental::Nester::Pod5;
use Moose;
with 'Pod::Elemental::Nester';
# ABSTRACT: the default, minimal semantics of Perl5's pod element hierarchy

use Moose::Autobox;

use namespace::autoclean;

use Pod::Elemental::Document;

=method nest_elements

  $nester->nest_elements(\@elements);

This method reorganizes the given elements into a tree.  It returns the same
reference it was given, which will have been reorganized in place.

Some elements may be dropped (like C<=cut> commands).

=cut

# TODO: handle the stupid verbatim-correction when inside non-colon-begin

sub transform_document {
  my ($self, $document) = @_;

  my $new = Pod::Elemental::Document->new;

  my $nodes = $document->children;
  for my $pos ($nodes->keys->flatten) {
    $new->children->push( $nodes->[ $pos ]);
  }

  return $new;
}

1;
