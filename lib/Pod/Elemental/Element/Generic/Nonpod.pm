package Pod::Elemental::Element::Generic::Nonpod;
# ABSTRACT: a non-pod element in a Pod document

use Moose;
with 'Pod::Elemental::Flat';

use namespace::autoclean;

=head1 OVERVIEW

Generic::Nonpod elements are just like Generic::Text elements, but represent
non-pod content found in the Pod stream.

=cut

__PACKAGE__->meta->make_immutable;

1;
