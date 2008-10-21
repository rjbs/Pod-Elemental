package Pod::Elemental;
use Moose;

use Mixin::Linewise::Readers -readers;
use Pod::Elemental::Nester;
use Pod::Elemental::Objectifier;
use Pod::Eventual::Simple;

has event_reader => (
  is => 'ro',
  required => 1,
  default  => sub { return Pod::Eventual::Simple->new },
);

has objectifier => (
  is => 'ro',
  required => 1,
  default  => sub { return Pod::Elemental::Objectifier->new },
);

has nester => (
  is => 'ro',
  required => 1,
  default  => sub { return Pod::Elemental::Nester->new },
);

sub read_handle {
  my ($self, $handle) = @_;
  $self = $self->new unless ref $self;

  my $events   = $self->event_reader->read_handle($handle);
  my $elements = $self->objectifier->objectify_events($events);
  $self->nester->nest_elements($elements);

  return $elements;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
