package Pod::Elemental::Document;
use Moose;
with 'Pod::Elemental::Node';
# ABSTRACT: a pod document

use Moose::Autobox;
use namespace::autoclean;

sub as_pod_string   {
  my ($self) = @_;

  join q{},
    "=pod\n\n",
    $self->children->map(sub { $_->as_pod_string })->flatten,
    "=cut\n";
}

sub as_debug_string { die }

1;
