package Pod::Elemental::Flat;
use Moose::Role;
# ABSTRACT: a content-only pod paragraph

use namespace::autoclean;

with 'Pod::Elemental::Paragraph';
excludes 'Pod::Elemental::Node';

1;
