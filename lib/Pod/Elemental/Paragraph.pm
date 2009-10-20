package Pod::Elemental::Paragraph;
use namespace::autoclean;
use Moose::Role;
use Moose::Autobox;

use Encode qw(encode);
use String::Truncate qw(elide);
# ABSTRACT: a paragraph in a Pod document

=attr content

This is the textual content of the element, as in a Pod::Eventual event, but
has its trailing newline chomped.  In other words, this POD:

  =head2 content

has a content of "content"

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
