package Pod::Elemental::Element::Pod5::Nonpod;
use Moose;
with 'Pod::Elemental::Flat';
with 'Pod::Elemental::Autoblank';
# ABSTRACT: a non-pod element in a POD document

use namespace::autoclean;

sub as_pod_string {
  my ($self) = @_;
  return sprintf "=cut\n%s=pod\n", $self->content;
}

sub as_debug_string { '?5' }

1;
