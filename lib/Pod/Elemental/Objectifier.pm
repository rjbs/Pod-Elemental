package Pod::Elemental::Objectifier;
use Moose;
use Moose::Autobox;
# ABSTRACT: it turns a Pod::Eventual event stream into objects

use namespace::autoclean;

use Pod::Elemental::Element::Blank;
use Pod::Elemental::Element::Command;
use Pod::Elemental::Element::Nonpod;
use Pod::Elemental::Element::Text;

=method element_class_for_event

This method returns the name of the class to be used for the given event.

=cut

sub __class_for {
  return {
    blank    => 'Pod::Elemental::Element::Blank',
    command  => 'Pod::Elemental::Element::Command',
    nonpod   => 'Pod::Elemental::Element::Nonpod',
    text     => 'Pod::Elemental::Element::Text',
  };
}

sub element_class_for_event {
  my ($self, $event) = @_;
  my $t = $event->{type};
  my $class_for = $self->__class_for;

  Carp::croak "unknown event type: $t" unless exists $class_for->{ $t };

  return $class_for->{ $t };
}

=method objectify_events

  my $elements = $objectifier->objectify_events(\@events);

Given an arrayref of POD events, this method returns an arrayref of
Pod::Elemental::Element objects formed from the event stream.

=cut

sub objectify_events {
  my ($self, $events) = @_;
  return $events->map(sub {
    Carp::croak("not a valid event") unless ref $_;

    my $class = $self->element_class_for_event($_);

    my %guts = (
      content    => $_->{content},
      start_line => $_->{start_line},

      ($_->{type} eq 'command' ? (command => $_->{command}) : ()),
    );

    chomp $guts{content} unless $_->{type} eq 'blank';

    $class->new(\%guts);
  });
}

1;
