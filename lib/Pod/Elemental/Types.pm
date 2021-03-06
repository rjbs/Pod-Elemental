use strict;
use warnings;
package Pod::Elemental::Types;
# ABSTRACT: data types for Pod::Elemental

use MooseX::Types -declare => [ qw(FormatName ChompedString) ];
use MooseX::Types::Moose qw(Str);

=head1 OVERVIEW

This is a library of MooseX::Types types used by Pod::Elemental.

=head1 TYPES

=head2 FormatName

This is a valid name for a format (a Pod5::Region).  It does not expect the
leading colon for pod-like regions.

=cut

# Probably needs refining -- rjbs, 2009-05-26
subtype FormatName, as Str, where { length $_ and /\A\S+\z/ };

=head2 ChompedString

This is a string that does not end with newlines.  It can be coerced from a
Str ending in a single newline -- the newline is dropped.

=cut

subtype ChompedString, as Str, where { ! /\n\z/ };
coerce ChompedString, from Str, via { chomp; $_ };

1;
