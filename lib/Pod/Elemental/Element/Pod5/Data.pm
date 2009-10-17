package Pod::Elemental::Element::Pod5::Data;
use Moose;
with 'Pod::Elemental::Paragraph';
# ABSTRACT: a POD data paragraph

use namespace::autoclean;

sub as_debug_string {
  return '(Pod5 Data)';
}

1;
