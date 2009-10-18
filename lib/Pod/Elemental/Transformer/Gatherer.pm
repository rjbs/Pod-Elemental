package Pod::Elemental::Transformer::Gatherer;
use Moose;
with 'Pod::Elemental::Transformer';
# ABSTRACT: gather related paragraphs under a shared header

use namespace::autoclean;

# so here you'll specify something like:
#   find all =method paragraphs in the list and put them under a new node (like
#   =head1 METHODS) and put that in place of the first =method paragraph

1;
