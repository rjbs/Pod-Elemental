package Pod::Elemental::Element::Pod5::Data;
use Moose;
extends 'Pod::Elemental::Element::Generic::Text';
with    'Pod::Elemental::Element::Pod5';
# ABSTRACT: a POD data paragraph

use namespace::autoclean;

sub as_debug_string {
  return '(Pod5 Data)';
}

1;
