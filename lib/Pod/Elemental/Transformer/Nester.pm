package Pod::Elemental::Transformer::Nester;
use Moose;
with 'Pod::Elemental::Transformer';
# ABSTRACT: group the document into sections

use namespace::autoclean;

# so here you'll specify something like:
#   head1  => [ things it can contain / things it can't contain ]
#   method => [ things it can contain / things it can't contain ]
# and it will go through the list of paragraphs, and nest all the "things a
# head1 can contain" under the head1, if they are subsequent to it
#
# we'll enforce the rule that nothing that can be contained can also be a
# container, if possible; probably not possible :-/

# DEFAULT: head1 => [ allow: =head2.., =over, =item, =back, *text ]

1;
