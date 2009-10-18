package Pod::Elemental::Element::Nested;
use Moose;
extends 'Pod::Elemental::Element::Generic::Command';
with 'Pod::Elemental::Node';
# ABSTRACT: an element that is a command and a node

use Moose::Autobox 0.10;

override as_pod_string => sub {
  my ($self) = @_;

  my $string = super;

  join q{},
    "$string\n",
    $self->children->map(sub { $_->as_pod_string })->flatten;
};

use namespace::autoclean;

1;
