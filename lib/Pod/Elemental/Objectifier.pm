package Pod::Elemental::Objectifier;
use Moose;
use Moose::Autobox;

use Pod::Elemental::Element;

sub objectify_events {
  my ($self, $events) = @_;
  return $events->map(sub {
    return unless ref; # in the future, we will return nonpod elements
    Pod::Elemental::Element->new($_)
  });
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
