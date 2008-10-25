package Pod::Elemental::Element::Nonpod;
use Moose;
extends 'Pod::Elemental::Element';
# ABSTRACT: a non-pod element in a POD document

use Moose::Autobox;

has '+type' => (default => 'nonpod');

sub as_debug_string {
  # TODO: include first line or so of content -- rjbs, 2008-10-25
  return "(non-POD)\n";
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
