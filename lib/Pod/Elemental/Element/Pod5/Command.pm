package Pod::Elemental::Element::Pod5::Command;
use Moose;
# ABSTRACT: a Pod5 =command element

extends 'Pod::Elemental::Element::Generic::Command';
with    'Pod::Elemental::Autoblank';
with    'Pod::Elemental::Autochomp';

=head1 OVERVIEW

Pod5::Command elements are identical to
L<Generic::Command|Pod::Elemental::Element::Generic::Command> elements, except
that they incorporate L<Pod::Elemental::Autoblank>.  They represent command
paragraphs in a Pod5 document.

=cut

use namespace::autoclean;

1;
