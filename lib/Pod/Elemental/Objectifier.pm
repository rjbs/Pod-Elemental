package Pod::Elemental::Objectifier;
use Moose;
use Moose::Autobox;

use Pod::Elemental::Element::Text;
use Pod::Elemental::Element::Command;

sub element_class_for_event_type {
  my ($self, $t) = @_;
  return 'Pod::Elemental::Element::Command' if $t eq 'command';
  return 'Pod::Elemental::Element::Text' if $t eq 'verbatim' or $t eq 'text';
  Carp::croak "unknown event type: $t";
}

sub objectify_events {
  my ($self, $events) = @_;
  return $events->map(sub {
    return unless ref; # in the future, we will return nonpod elements

    my $class = $self->element_class_for_event_type($_->{type});

    my %guts = (
      type       => $_->{type},
      content    => $_->{content},
      start_line => $_->{start_line},

      ($_->{type} eq 'command' ? (command => $_->{command}) : ()),
    );

    chomp for values %guts;

    $class->new(\%guts);
  });
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
