#!perl
use strict;
use warnings;

use Test::More;
use Test::Differences;

use Moose::Autobox;
use Pod::Eventual::Simple;
use Pod::Elemental;
use Pod::Elemental::Selectors -all;
use Pod::Elemental::Transformer::Pod5;
use Pod::Elemental::Transformer::Nester;

my $str = do { local $/; <DATA> };

my $document = Pod::Elemental->read_string($str);

Pod::Elemental::Transformer::Pod5->transform_node($document);

my $nester = Pod::Elemental::Transformer::Nester->new({
  top_selector => s_command('head1'),
  content_selectors => [
    s_flat,
    s_command( [ qw(head2 head3 head4 over item back) ]),
  ],
});

$nester->transform_node($document);

diag $document->as_debug_string;

done_testing;

__DATA__
=pod

Ordinary Paragraph 1.1

=head1 Header 1.1

=head2 Header 2.1

=head2 Header 2.2

Ordinary Paragraph 2.1

=head3 Header 3.1

=over 4

=item * foo

=back

=head1 Header 1.2

Ordinary Paragraph 2.1
