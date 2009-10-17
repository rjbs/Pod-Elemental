package Pod::Elemental::Element::Generic::Nonpod;
use Moose;
with 'Pod::Elemental::Paragraph';
# ABSTRACT: a non-pod element in a POD document

use namespace::autoclean;

sub as_debug_string { '??' }

1;
