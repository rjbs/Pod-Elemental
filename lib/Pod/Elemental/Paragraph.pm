package Pod::Elemental::Paragraph;
use namespace::autoclean;
use Moose::Role;
use Moose::Autobox;
# ABSTRACT: a paragraph in a Pod document

with 'Pod::Elemental::Node';

requires 'type';

=attr type

The type is a string giving a type for the element, like F<text> or F<nonpod>
or F<command>.  These are generally the same as the event types from the event
reader.

=attr content

This is the textual content of the element, as in a Pod::Eventual event, but
has its trailing newline chomped.  In other words, this POD:

  =head2 content

has a content of "content"

=attr start_line

This attribute, which may or may not be set, indicates the line in the source
document where the element began.

=cut

has content    => (is => 'ro', isa => 'Str', required => 1);
has start_line => (is => 'ro', isa => 'Int', required => 0);

=method as_pod_string

This returns the element  as a string, suitable for turning elements back into
a document.  Some elements, like a C<=over> command, will stringify to include
extra content like a C<=back> command.  In the case of elements with children,
this method will include the stringified children as well.

=cut

sub as_pod_string {
  my ($self) = @_;
  return $self->content . "\n";
}

=method as_debug_string

This method returns a string, like C<as_string>, but is meant for getting an
overview of the document structure, and is not suitable for reproducing a
document.  Its exact output is likely to change over time.

=cut

sub as_debug_string {
  my ($self) = @_;
  return $self->as_string;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
