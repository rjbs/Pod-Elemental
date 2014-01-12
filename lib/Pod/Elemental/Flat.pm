package Pod::Elemental::Flat;
# ABSTRACT: a content-only pod paragraph

use Moose::Role;

use namespace::autoclean;

=head1 OVERVIEW

Pod::Elemental::Flat is a role that is included to indicate that a class
represents a Pod paragraph that will have no children, and represents only its
own content.  Generally it is used for text paragraphs.

=cut

with 'Pod::Elemental::Paragraph';
excludes 'Pod::Elemental::Node';

sub as_debug_string {
  my ($self) = @_;

  my $moniker = ref $self;
  $moniker =~ s/\APod::Elemental::Element:://;

  my $summary = $self->_summarize_string($self->content);

  return "$moniker <$summary>";
}

1;
