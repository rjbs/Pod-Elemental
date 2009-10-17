package Pod::Elemental::Element::Generic::Text;
use Moose;
with 'Pod::Elemental::Paragraph';
# ABSTRACT: a POD text or verbatim element

use namespace::autoclean;

sub as_debug_string {
  return '(Generic Text)';
}

1;
