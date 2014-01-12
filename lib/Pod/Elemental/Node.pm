package Pod::Elemental::Node;
# ABSTRACT: a thing with Pod::Elemental::Nodes as children

use Moose::Role;

use namespace::autoclean;

use Moose::Autobox;
use MooseX::Types;
use MooseX::Types::Moose qw(ArrayRef);
use Moose::Util::TypeConstraints qw(class_type);

requires 'as_pod_string';
requires 'as_debug_string';

=head1 OVERVIEW

Classes that include Pod::Elemental::Node represent collections of child
Pod::Elemental::Paragraphs.  This includes Pod documents, Pod5 regions, and
nested Pod elements produced by the Gatherer transformer.

=attr children

This attribute is an arrayref of
L<Pod::Elemental::Node|Pod::Elemental::Node>-performing objects, and represents
elements contained by an object.

=cut

has children => (
  is   => 'rw',
  isa  => ArrayRef[ role_type('Pod::Elemental::Paragraph') ],
  required   => 1,
  default    => sub { [] },
);

around as_debug_string => sub {
  my ($orig, $self) = @_;

  my $str = $self->$orig;

  my @children = map { $_->as_debug_string } $self->children->flatten;
  s/^/  /sgm for @children;

  $str = join "\n", $str, @children;

  return $str;
};

1;
