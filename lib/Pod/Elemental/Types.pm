use strict;
use warnings;
package Pod::Elemental::Types;
# ABSTRACT: data types for Pod::Elemental
use MooseX::Types -declare => [ qw(FormatName) ];
use MooseX::Types::Moose qw(Str);

# Probably needs refining -- rjbs, 2009-05-26
subtype FormatName, as Str, where { length $_ and /\A\S+\z/ };

1;
