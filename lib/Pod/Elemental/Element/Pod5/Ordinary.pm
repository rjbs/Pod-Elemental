package Pod::Elemental::Element::Pod5::Ordinary;
use Moose;
extends 'Pod::Elemental::Element::Generic::Text';
with    'Pod::Elemental::Autoblank';
# ABSTRACT: a Pod5 ordinary text paragraph

use namespace::autoclean;

1;
