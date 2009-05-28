package Pod::Elemental::Document;
use Moose;
with 'Pod::Elemental::Node';
# ABSTRACT: a pod document

use namespace::autoclean;

sub as_pod_string { die }
sub as_debug_string { die }

1;
