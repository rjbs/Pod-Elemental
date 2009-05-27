package Pod::Elemental::Command;
use Moose::Role;
with 'Pod::Elemental::Paragraph';
# ABSTRACT: a =command paragraph

use Moose::Autobox;

requires 'command';

1;
