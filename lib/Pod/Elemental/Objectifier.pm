package Pod::Elemental::Objectifier;
# ABSTRACT: it turns a Pod::Eventual event stream into objects

use Moose;
use Moose::Autobox;

=head1 OVERVIEW

An objectifier is responsible for taking the events produced by
L<Pod::Eventual|Pod::Eventual> and converting them into objects that perform
the Pod::Elemental::Paragraph role.

In general, it does this by producing a sequence of element objects in the
Pod::Elemental::Element::Generic namespace.

=cut

use namespace::autoclean;

use Pod::Elemental::Element::Generic::Blank;
use Pod::Elemental::Element::Generic::Command;
use Pod::Elemental::Element::Generic::Nonpod;
use Pod::Elemental::Element::Generic::Text;

=method objectify_events

  my $elements = $objectifier->objectify_events(\@events);

Given an arrayref of Pod events, this method returns an arrayref of objects
formed from the event stream.

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

    $class->new(\%guts);
  });
}


=method element_class_for_event

This method returns the name of the class to be used for the given event.

=cut

sub __class_for {
  return {
    blank    => 'Pod::Elemental::Element::Generic::Blank',
    command  => 'Pod::Elemental::Element::Generic::Command',
    nonpod   => 'Pod::Elemental::Element::Generic::Nonpod',
    text     => 'Pod::Elemental::Element::Generic::Text',
  };
}

sub element_class_for_event {
  my ($self, $event) = @_;
  my $t = $event->{type};
  my $class_for = $self->__class_for;

  Carp::croak "unknown event type: $t" unless exists $class_for->{ $t };

  return $class_for->{ $t };
}

1;
