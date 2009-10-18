package Pod::Elemental::Element::Pod5;
use namespace::autoclean;
use Moose::Role;
# ABSTRACT: a paragraph in a Pod document

around as_pod_string => sub {
  my ($orig, $self, @arg) = @_;
  my $str = $self->$orig(@arg);
  "$str\n";
};

1;
