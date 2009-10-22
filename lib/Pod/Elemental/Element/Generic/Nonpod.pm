package Pod::Elemental::Element::Generic::Nonpod;
use Moose;
with 'Pod::Elemental::Flat';
# ABSTRACT: a non-pod element in a Pod document

use namespace::autoclean;

=head1 OVERVIEW

Generic::Nonpod elements are just like Generic::Text elements, but represent
non-pod content found in the Pod stream.

=cut

1;
