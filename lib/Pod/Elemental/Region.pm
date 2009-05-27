package Pod::Elemental::Region;
use Moose::Role;
with 'Pod::Elemental::Paragraph';
# ABSTRACT: a command that establishes a region

use Pod::Elemental::Types qw(FormatName);
use MooseX::Types::Moose qw(Bool);

requires 'closing_command';

1;
