#!perl
use strict;
use warnings;

# PURPOSE:
# show that begin/end are turned into regions with the correct properties

use Test::More;

exit;

use Pod::Elemental;
use Pod::Elemental::Transformer::Pod5;

my $content  = do { local $/; <DATA> };
my $doc_orig = Pod::Elemental->read_string($content);

my $doc_pod5 = Pod::Elemental::Transformer::Pod5->new->transform_document(
  $doc_orig,
);

__DATA__

=head1 Header 1

Ordinary 1

=begin :podlike

Ordinary 2

Ordinary 3

  Verbatim 1

  Verbatim 2

Ordinary 4

=head2 Header 2

=begin data

Data 1

Data 2

  Data 3

Data 4

=end data

=head3 Header 3

  Verbatim 3

  Verbatim 4

Orindary 5

=end :podlike

