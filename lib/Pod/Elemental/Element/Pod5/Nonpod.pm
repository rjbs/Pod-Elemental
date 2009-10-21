package Pod::Elemental::Element::Pod5::Nonpod;
use Moose;
with 'Pod::Elemental::Flat';
with 'Pod::Elemental::Autoblank';
# ABSTRACT: a non-pod element in a Pod document

=head1 OVERVIEW

A Pod5::Nonpod element represents a hunk of non-Pod content found in a Pod
document tree.  It is equivalent to a
L<Generic::Nonpod|Pod::Elemental::Element::Generic::Nonpod> element, with the
following differences:

=over 4

=item * it includes L<Pod::Elemental::Autoblank>

=item * when producing a pod string, it wraps the non-pod content in =cut/=pod

=back

=cut

use namespace::autoclean;

sub as_pod_string {
  my ($self) = @_;
  return sprintf "=cut\n%s=pod\n", $self->content;
}

1;
