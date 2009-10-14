package Pod::Elemental::Document;
use Moose;
with 'Pod::Elemental::Node';
# ABSTRACT: a pod document

use Moose::Autobox;
use namespace::autoclean;

use Pod::Elemental::Element::Generic::Blank;
my $GENERIC = 'Pod::Elemental::Element::Generic::';

sub as_pod_string {
  my ($self) = @_;

  join q{},
    "=pod\n\n",
    $self->children->map(sub { $_->as_pod_string })->flatten,
    "=cut\n";
}

sub as_debug_string { die }

sub new_from_lol {
  my ($class, $lol) = @_;

  my $self = $class->new;

  my @children;
  ENTRY: for my $entry (@$lol) {
    my ($type, $content, $arg) = @$entry;
    $arg ||= {};

    if (! defined $type) {
      my $n_class = $arg->{class} || "${GENERIC}Text";
      Class::MOP::load_class($n_class);
      push @children, $n_class->new({ content => "$content\n" });
    } elsif ($type =~ /\A=(\w+)\z/) {
      my $command = $1;
      my $n_class = $arg->{class} || "${GENERIC}Command";
      Class::MOP::load_class($n_class);
      push @children, $n_class->new({
        command => $command,
        content => "$content\n"
      });
    } else {
      # die "unimplemented";
    }
  } continue {
    my $blank = "${GENERIC}Blank";
    push @children, $blank->new({ content => "\n" });
  }

  push @{ $self->children }, @children;

  return $self;
}

1;
