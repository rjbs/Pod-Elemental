package Pod::Elemental::Element::Data;
use Moose;
extends 'Pod::Elemental::Element';
# ABSTRACT: a POD data paragraph

use Moose::Autobox;

has '+type' => (default => 'data');

__PACKAGE__->meta->make_immutable;
no Moose;
1;
