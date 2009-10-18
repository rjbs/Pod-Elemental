package Pod::Elemental::Element::Pod5;
use namespace::autoclean;
use Moose::Role;
# ABSTRACT: a paragraph in a Pod document

override as_pod_string => sub {
  my $str = super;
  "$str\n";
};

1;
