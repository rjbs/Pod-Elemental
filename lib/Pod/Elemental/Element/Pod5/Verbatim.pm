package Pod::Elemental::Element::Pod5::Verbatim;
use Moose;
with 'Pod::Elemental::Paragraph';
# ABSTRACT: a POD verbatim element

use namespace::autoclean;

sub as_debug_string {
  return '(Pod5 Verbatim)';
}

1;
