package Pod::Elemental::Objectifier;
use Moose;
use Moose::Autobox;
# ABSTRACT: it turns a Pod::Eventual event stream into objects

use Pod::Elemental::Element::Command;
use Pod::Elemental::Element::Nonpod;
use Pod::Elemental::Element::Text;

=method element_class_for_event

This method returns the name of the class to be used for the given event.

=cut

sub element_class_for_event {
  my ($self, $event) = @_;
  my $t = $event->{type};
  return 'Pod::Elemental::Element::Command' if $t eq 'command';
  return 'Pod::Elemental::Element::Text' if $t eq 'verbatim' or $t eq 'text';
  return 'Pod::Elemental::Element::Nonpod' if $t eq 'nonpod';
  Carp::croak "unknown event type: $t";
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
    return if $_->{type} eq 'blank';

    my $class = $self->element_class_for_event($_);

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
