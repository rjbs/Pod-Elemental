package Pod::Elemental::Element::Pod5::Ordinary;
use Moose;
with 'Pod::Elemental::Paragraph';
# ABSTRACT: a Pod5 ordinary text paragraph

use namespace::autoclean;

sub as_debug_string {
  return '(Pod5 Ordinary)';
}

1;
