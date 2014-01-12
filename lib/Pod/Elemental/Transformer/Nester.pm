package Pod::Elemental::Transformer::Nester;
# ABSTRACT: group the document into sections

use Moose;
with 'Pod::Elemental::Transformer';

=head1 OVERVIEW

The Nester transformer is meant to find potential container elements and make
them into actual containers.  It works by being told what elements may be made
into containers and what subsequent elements they should allow to be stuffed
into them.

For example, given the following nester:

  use Pod::Elemental::Selectors qw(s_command s_flat);

  my $nester = Pod::Elemental::Transformer::Nester->new({
    top_selector      => s_command('head1'),
    content_selectors => [
      s_command([ qw(head2 head3 head4) ]),
      s_flat,
    ],
  });

..then when we apply the transformation:

  $nester->transform_node($document);

...the nester will find all C<=head1> elements in the top-level of the
document.  It will ensure that they are represented by objects that perform the
Pod::Elemental::Node role, and then it will move all subsequent elements
matching the C<content_selectors> into the container.

So, if we start with this input:

  =head1 Header
  =head2 Subheader
  Pod5::Ordinary <some content>
  =head1 New Header

The nester will convert its structure to look like this:

  =head1 Header
    =head2 Subheader
    Pod5::Ordinary <some content>
  =head1 New Header

Once an element is reached that does not pass the content selectors, the
nesting ceases until the next potential container.

=cut

use Moose::Autobox 0.10;
use MooseX::Types::Moose qw(ArrayRef CodeRef);

use Pod::Elemental::Element::Nested;
use Pod::Elemental::Selectors -all;

use namespace::autoclean;

=attr top_selector

This attribute must be a coderef (presumably made from
Pod::Elemental::Selectors) that will test elements in the transformed node and
return true if the element is a potential new container.

=cut

has top_selector => (
  is  => 'ro',
  isa => CodeRef,
  required => 1,
);

=attr content_selectors

This attribute must be an arrayref of coderefs (again presumably made from
Pod::Elemental::Selectors) that will test whether paragraphs subsequent to the
top-level container may be moved under the container.

=cut

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

  # We used to say (length -2) because "if we're already at the last element,
  # we can't nest anything -- there's nothing subsequent to the potential
  # top-level element to nest!" -- my (rjbs's) reasoning in 2009.
  #
  # This was an unneeded optimization, and therefore stupid.  Worse, it was a
  # bug.  It meant that a nestable element that was the last element in a
  # sequence wouldn't be upgraded to a Nested element, so later munging could
  # barf.  In fact, that's what happened in [rt.cpan.org #69189]
  # -- rjbs, 2012-05-04
  PASS: for my $i (0 .. $node->children->length - 1) {
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
