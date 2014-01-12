package Pod::Elemental::Autochomp;
# ABSTRACT: a paragraph that chomps set content

use namespace::autoclean;
use Moose::Role;

use Pod::Elemental::Types qw(ChompedString);

=head1 OVERVIEW

This role exists primarily to simplify elements produced by the Pod5
transformer.

=cut

# has '+content' => (
#   coerce => 1,
#   isa    => ChompedString,
# );

1;
