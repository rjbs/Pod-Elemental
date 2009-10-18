package Pod::Elemental::Transformer::Nester;
use Moose;
with 'Pod::Elemental::Transformer';
# ABSTRACT: group the document into sections

use Moose::Autobox 0.10;
use MooseX::Types::Moose qw(ArrayRef CodeRef);

use Pod::Elemental::Element::Nested;
use Pod::Elemental::Selectors -all;

use namespace::autoclean;

# so here you'll specify something like:
#   head1  => [ things it can contain / things it can't contain ]
#   method => [ things it can contain / things it can't contain ]
# and it will go through the list of paragraphs, and nest all the "things a
# head1 can contain" under the head1, if they are subsequent to it
#
# we'll enforce the rule that nothing that can be contained can also be a
# container, if possible; probably not possible :-/
#
# DEFAULT: head1 => [ allow: =head2.., =over, =item, =back, *text ]

has top_selector => (
  is  => 'ro',
  isa => CodeRef,
  required => 1,
);

has content_selectors => (
  is  => 'ro',
  isa => ArrayRef[ CodeRef ],
  required => 1,
);

sub _is_containable {
  my ($self, $para) = @_;

  for my $sel ($self->content_selectors->flatten) {
    return 1 if $sel->($para);
  }

  return;
}

sub transform_node {
  my ($self, $node) = @_;

  # We use -2 because if we're already at the last element, we can't nest
  # anything -- there's nothing subsequent to the potential top-level element
  # to nest! -- rjbs, 2009-10-18
  PASS: for my $i (0 .. $node->children->length - 2) {
    last PASS if $i >= $node->children->length;

    my $para = $node->children->[ $i ];
    next unless $self->top_selector->($para);

    if (s_command(undef, $para) and not s_node($para)) {
      $para = $node->children->[ $i ] = Pod::Elemental::Element::Nested->new({
        command => $para->command,
        content => $para->content,
      });
    }

    if (! s_node($para) or $para->children->length) {
      confess "can't use $para as the top of a nesting";
    }

    my @to_nest;
    NEST: for my $j ($i+1 .. $node->children->length - 1) {
      last unless $self->_is_containable($node->children->[ $j ]);
      push @to_nest, $j;
    }

    if (@to_nest) {
      my @to_nest_elem = 
        splice @{ $node->children }, $to_nest[0], scalar(@to_nest);

      $para->children->push(@to_nest_elem);
      next PASS;
    }
  }

  return $node;
}

1;
