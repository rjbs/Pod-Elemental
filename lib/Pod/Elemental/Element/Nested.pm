package Pod::Elemental::Element::Nested;
use Moose;
extends 'Pod::Elemental::Element::Generic::Command';
with 'Pod::Elemental::Node';
with 'Pod::Elemental::Autochomp';
# ABSTRACT: an element that is a command and a node

use namespace::autoclean;

use Moose::Autobox 0.10;

# BEGIN Autochomp Replacement
use Pod::Elemental::Types qw(ChompedString);
has '+content' => (coerce => 1, isa => ChompedString);
# END   Autochomp Replacement

=head1 WARNING

This class is somewhat sketchy and may be refactored somewhat in the future,
specifically to refactor its similarities to
L<Pod::Elemental::Element::Pod5::Region>.

=head1 OVERVIEW

A Nested element is a Generic::Command element that is also a node.

It's used by the nester transformer to produce commands with children, to make
documents seem more structured for easy manipulation.

=cut

override as_pod_string => sub {
  my ($self) = @_;

  my $string = super;

  $string = join q{},
    "$string\n\n",
    $self->children->map(sub { $_->as_pod_string })->flatten;

  $string =~ s/\n{3,}\z/\n\n/g;

  return $string;
};

1;
