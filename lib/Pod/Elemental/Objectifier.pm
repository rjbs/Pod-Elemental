package Pod::Elemental::Objectifier;
use Moose;
use Moose::Autobox;

use Pod::Elemental::Element;

sub objectify_events {
  my ($self, $events) = @_;
  return $events->map(sub {
    return unless ref; # in the future, we will return nonpod elements
    my %guts = (
      type       => $_->{type},
      content    => $_->{content},
      start_line => $_->{start_line},

      ($_->{command} ? (command => $_->{command}) : ()),
    );

    chomp for values %guts;
      
    Pod::Elemental::Element->new(\%guts);
  });
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
