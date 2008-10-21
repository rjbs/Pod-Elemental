package Pod::Elemental::Element::Text;
use Moose;
extends 'Pod::Elemental::Element';

use Moose::Autobox;

sub as_hash {
  my ($self) = @_;

  return {
    type    => $self->type,
    content => $self->content,
  };
}

sub as_string {
  my ($self) = @_;
  return $self->content . "\n";
}

sub as_debug_string {
  my ($self) = @_;
  return $self->as_string;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
