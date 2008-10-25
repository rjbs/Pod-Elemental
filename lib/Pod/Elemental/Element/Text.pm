package Pod::Elemental::Element::Text;
use Moose;
extends 'Pod::Elemental::Element';
# ABSTRACT: a POD text or verbatim element

use Moose::Autobox;

has '+type' => (default => 'text');

__PACKAGE__->meta->make_immutable;
no Moose;
1;
