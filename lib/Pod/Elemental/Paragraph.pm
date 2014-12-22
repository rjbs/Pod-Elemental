package Pod::Elemental::Paragraph;
# ABSTRACT: a paragraph in a Pod document

use namespace::autoclean;
use Moose::Role;

use Encode qw(encode);
use String::Truncate qw(elide);

=head1 OVERVIEW

This is probably the most important role in the Pod-Elemental distribution.
Classes including this role represent paragraphs in a Pod document.  The
paragraph is the fundamental unit of dividing up Pod documents, so this is a
often-included role.

=attr content

This is the textual content of the element, as in a Pod::Eventual event.  In
other words, this Pod:

  =head2 content

has a content of "content\n"

=attr start_line

This attribute, which may or may not be set, indicates the line in the source
document where the element began.

=cut

has content    => (is => 'rw', isa => 'Str', required => 1);
has start_line => (is => 'ro', isa => 'Int', required => 0);

=method as_pod_string

This returns the element  as a string, suitable for turning elements back into
a document.  Some elements, like a C<=over> command, will stringify to include
extra content like a C<=back> command.  In the case of elements with children,
this method will include the stringified children as well.

=cut

sub as_pod_string {
  my ($self) = @_;
  return $self->content;
}

=method as_debug_string

This method returns a string, like C<as_string>, but is meant for getting an
overview of the document structure, and is not suitable for reproducing a
document.  Its exact output is likely to change over time.

=cut

sub _summarize_string {
  my ($self, $str, $length) = @_;
  $length ||= 30;

  use utf8;
  chomp $str;
  my $elided = elide($str, $length, { truncate => 'middle', marker => '…' });
  $elided =~ tr/\n\t/␤␉/;

  return encode('utf-8', $elided);
}

requires 'as_debug_string';

1;
