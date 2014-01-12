package Pod::Elemental::Element::Generic::Blank;
# ABSTRACT: a series of blank lines

use Moose;
with 'Pod::Elemental::Flat';

=head1 OVERVIEW

Generic::Blank elements represent vertical whitespace in a Pod document.  For
the most part, these are meant to be placeholders until made unnecessary by the
Pod5 transformer.  Most end-users will never need to worry about these
elements.

=cut

use namespace::autoclean;

sub as_debug_string { '|' }

1;
