package Pod::Elemental::Element::Generic::Blank;
use Moose;
with 'Pod::Elemental::Paragraph';
# ABSTRACT: a series of blank lines

use namespace::autoclean;

sub as_debug_string { '|' }

1;
