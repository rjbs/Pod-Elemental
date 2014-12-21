package Pod::Elemental;
# ABSTRACT: work with nestable Pod elements

use Moose;

use namespace::autoclean;

use Sub::Exporter::ForMethods ();
use Mixin::Linewise::Readers
  { installer => Sub::Exporter::ForMethods::method_installer },
  -readers;

use MooseX::Types;

use Pod::Eventual::Simple 0.004; # nonpod events
use Pod::Elemental::Document;
use Pod::Elemental::Transformer::Pod5;
use Pod::Elemental::Objectifier;

=head1 DESCRIPTION

Pod::Elemental is a system for treating a Pod (L<plain old
documentation|perlpod>) documents as trees of elements.  This model may be
familiar from many other document systems, especially the HTML DOM.
Pod::Elemental's document object model is much less sophisticated than the HTML
DOM, but still makes a lot of document transformations easy.

In general, you'll want to read in a Pod document and then perform a number of
prepackaged transformations on it.  The most common of these will be the L<Pod5
transformation|Pod::Elemental::Transformer::Pod5>, which assumes that the basic
meaning of Pod commands described in the Perl 5 documentation hold: C<=begin>,
C<=end>, and C<=for> commands mark regions of the document, leading whitespace
marks a verbatim paragraph, and so on.  The Pod5 transformer also eliminates
the need to track elements representing vertical whitespace.

=head1 SYNOPSIS

  use Pod::Elemental;
  use Pod::Elemental::Transformer::Pod5;

  my $document = Pod::Elemental->read_file('lib/Pod/Elemental.pm');

  Pod::Elemental::Transformer::Pod5->new->transform_node($document);

  print $document->as_debug_string, "\n"; # quick overview of doc structure

  print $document->as_pod_string, "\n";   # reproduce the document in Pod

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
C<objectify_events> method that converts Pod events into
Pod::Elemental::Element objects.

=cut

has objectifier => (
  is  => 'ro',
  isa => duck_type( [qw(objectify_events) ]),
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

__PACKAGE__->meta->make_immutable;
no Moose;
1;
