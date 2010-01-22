package Pod::Elemental::Element::Pod5::Ordinary;
use Moose;
extends 'Pod::Elemental::Element::Generic::Text';
with    'Pod::Elemental::Autoblank';
with    'Pod::Elemental::Autochomp';
# ABSTRACT: a Pod5 ordinary text paragraph

# BEGIN Autochomp Replacement
use Pod::Elemental::Types qw(ChompedString);
has '+content' => (coerce => 1, isa => ChompedString);
# END   Autochomp Replacement

=head1 OVERVIEW

A Pod5::Ordinary element represents a plain old paragraph of text found in a
Pod document that's gone through the Pod5 translator.

=cut

use namespace::autoclean;

1;
