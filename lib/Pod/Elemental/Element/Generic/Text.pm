package Pod::Elemental::Element::Generic::Text;
use Moose;
with 'Pod::Elemental::Flat';
# ABSTRACT: a POD text or verbatim element

use namespace::autoclean;

=head1 OVERVIEW

Generic::Text elements represent text paragraphs found in raw Pod.  They are
likely to be fed to a Pod5 translator and converted to ordinary, verbatim, or
data paragraphs in that dialect.  Otherwise, Generic::Text paragraphs are
simple flat paragraphs.

=cut

1;
