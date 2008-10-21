package Pod::Elemental::Element;
use Moose;
use Moose::Autobox;

has type       => (is => 'ro', isa => 'Str', required => 1);
has content    => (is => 'ro', isa => 'Str', required => 1);
has command    => (is => 'ro', isa => 'Str', required => 0);
has start_line => (is => 'ro', isa => 'Int', required => 0);

__PACKAGE__->meta->make_immutable;
no Moose;
1;
