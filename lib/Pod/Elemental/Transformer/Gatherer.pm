package Pod::Elemental::Transformer::Gatherer;
use Moose;
with 'Pod::Elemental::Transformer';
# ABSTRACT: gather related paragraphs under a shared header

use namespace::autoclean;

use Moose::Autobox 0.10;
use MooseX::Types::Moose qw(CodeRef);
use Pod::Elemental::Node;

# so here you'll specify something like:
#   find all =method paragraphs in the list and put them under a new node (like
#   =head1 METHODS) and put that in place of the first =method paragraph

has gather_selector => (
  is  => 'ro',
  isa => CodeRef,
  required => 1,
);

has container => (
  is   => 'ro',
  does => 'Pod::Elemental::Node',
  required => 1,
);

sub transform_node {
  my ($self, $node) = @_;

  my @indexes;
  for my $i (0 .. $node->children->length - 1) {
    push @indexes, $i if $self->gather_selector->($node->children->[ $i ]);
  }

  my @paras;
  for my $idx (reverse @indexes) {
    unshift @paras, splice @{ $node->children }, $idx, 1;
  }

  $self->container->children(\@paras);

  splice @{ $node->children }, $indexes[0], 0, $self->container;

  return $node;
}

1;
