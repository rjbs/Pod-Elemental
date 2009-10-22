package Pod::Elemental::Element::Pod5::Data;
use Moose;
extends 'Pod::Elemental::Element::Generic::Text';
# ABSTRACT: a POD data paragraph

=head1 OVERVIEW

Pod5::Data paragraphs represent the content of
L<Pod5::Region|Pod::Elemental::Element::Pod5::Region> paragraphs when the
region is not a Pod-like region.  These regions should generally have a single
data element contained in them.

=cut

use namespace::autoclean;

1;
