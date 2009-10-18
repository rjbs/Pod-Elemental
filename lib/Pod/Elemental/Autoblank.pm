package Pod::Elemental::Autoblank;
use namespace::autoclean;
use Moose::Role;
# ABSTRACT: a paragraph that always displays an extra blank line in Pod form

around as_pod_string => sub {
  my ($orig, $self, @arg) = @_;
  my $str = $self->$orig(@arg);
  "$str\n";
};

1;
