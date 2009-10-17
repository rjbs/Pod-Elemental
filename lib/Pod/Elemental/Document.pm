package Pod::Elemental::Document;
use Moose;
with 'Pod::Elemental::Node';
# ABSTRACT: a pod document

use Moose::Autobox;
use namespace::autoclean;

use Pod::Elemental::Element::Generic::Blank;
use String::RewritePrefix;

sub _expand_name {
  my ($self, $name) = @_;

  return String::RewritePrefix->rewrite(
    {
      '' => 'Pod::Elemental::Element::',
      '=' => ''
    },
    $name,
  );
}

sub as_pod_string {
  my ($self) = @_;

  join q{},
    "=pod\n\n",
    $self->children->map(sub { $_->as_pod_string })->flatten,
    "=cut\n";
}

sub as_debug_string { die }

sub _elem_from_lol_entry {
  my ($self, $entry) = @_;
  my ($type, $content, $arg) = @$entry;
  $arg ||= {};

  if (! defined $type) {
    my $n_class = $self->_expand_name($arg->{class} || 'Generic::Text');
    Class::MOP::load_class($n_class);
    return $n_class->new({ content => "$content\n" });
  } elsif ($type =~ /\A=(\w+)\z/) {
    my $command = $1;
    my $n_class = $self->_expand_name($arg->{class} || 'Generic::Command');
    Class::MOP::load_class($n_class);
    return $n_class->new({
      command => $command,
      content => "$content\n"
    });
  } else {
    my $n_class = $self->_expand_name($arg->{class} || 'Pod5::Region');
    Class::MOP::load_class($n_class);

    my @children = $self->_expand_name('Generic::Blank')->new({
      content => "\n",
    });

    for my $child (@$content) {
      push @children, $self->_elem_from_lol_entry($child);
    } continue {
      my $blank = $self->_expand_name('Generic::Blank');
      push @children, $blank->new({ content => "\n" });
    }

    my ($colon, $target) = $type =~ /\A(:)?(.+)\z/;

    return $n_class->new({
      format_name => $target,
      is_pod      => $colon ? 1 : 0,
      content     => "\n",
      children    => \@children,
    })
  }
}

sub new_from_lol {
  my ($class, $lol) = @_;

  my $self = $class->new;

  my @children;
  ENTRY: for my $entry (@$lol) {
    my $elem = $self->_elem_from_lol_entry($entry);
    push @children, $elem;
  } continue {
    my $blank = $self->_expand_name('Generic::Blank');
    push @children, $blank->new({ content => "\n" });
  }

  push @{ $self->children }, @children;

  return $self;
}

1;
