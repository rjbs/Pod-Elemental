package Pod::Elemental::Element::Pod5::Verbatim;
use Moose;
extends 'Pod::Elemental::Element::Generic::Text';
with    'Pod::Elemental::Autoblank';
# ABSTRACT: a POD verbatim element

use namespace::autoclean;

1;
