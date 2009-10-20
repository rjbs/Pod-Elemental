package Pod::Elemental::Flat;
use Moose::Role;
# ABSTRACT: a content-only pod paragraph

use namespace::autoclean;

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
