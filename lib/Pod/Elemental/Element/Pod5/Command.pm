package Pod::Elemental::Element::Pod5::Command;
use Moose;
# ABSTRACT: a Pod5 =command element

extends 'Pod::Elemental::Element::Generic::Command';
with    'Pod::Elemental::Element::Pod5';

use namespace::autoclean;

1;
