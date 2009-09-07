package Pod::Elemental;
use Moose;
use Moose::Autobox;
# ABSTRACT: work with nestable POD elements

use Mixin::Linewise::Readers -readers;

use Pod::Elemental::Document;
use Pod::Elemental::Element;
use Pod::Elemental::Transformer::Pod5;
use Pod::Elemental::Objectifier;
use Pod::Eventual::Simple;

=attr event_reader

The event reader (by default a new instance of
L<Pod::Eventual::Simple|Pod::Eventual::Simple> is used to convert input into an
event stream.  In general, it should provide C<read_*> methods that behave like
Pod::Eventual::Simple.

=cut

has event_reader => (
  is => 'ro',
  required => 1,
  default  => sub { return Pod::Eventual::Simple->new },
);

=attr objectifier

The objectifier (by default a new Pod::Elemental::Objectifier) must provide an
C<objectify_events> method that converts POD events into
Pod::Elemental::Element objects.

=cut

has objectifier => (
  is => 'ro',
  required => 1,
  default  => sub { return Pod::Elemental::Objectifier->new },
);

=attr document_class

This is the class for documents created by reading pod.

=cut

has document_class => (
  is       => 'ro',
  required => 1,
  default  => 'Pod::Elemental::Document',
);

=method read_handle

=method read_file

=method read_string

These methods read the given input and return a Pod::Elemental::Document.

=cut

sub read_handle {
  my ($self, $handle) = @_;
  $self = $self->new unless ref $self;

  my $events   = $self->event_reader->read_handle($handle);
  my $elements = $self->objectifier->objectify_events($events);

  my $document = $self->document_class->new({
    children => $elements,
  });

  return $document;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
