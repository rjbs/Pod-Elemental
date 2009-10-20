#!perl
use strict;
use warnings;

# PURPOSE:
# show that we can have a "foo" region inside another "foo" region

use Test::More tests => 1;
use Test::Deep;
use Test::Differences;

use Moose::Autobox;
use Pod::Eventual::Simple;
use Pod::Elemental::Objectifier;
use Pod::Elemental::Transformer::Pod5;
use Pod::Elemental::Document;

my $str = do { local $/; <DATA> };

my $events   = Pod::Eventual::Simple->read_string($str);
my $elements = Pod::Elemental::Objectifier->objectify_events($events);

my $document = Pod::Elemental::Document->new({
  children => $elements
});

Pod::Elemental::Transformer::Pod5->transform_node($document);

# eq_or_diff($document->as_pod_string, $str, 'we got what we expected');

diag $document->as_debug_string;

diag $document->as_pod_string;

__DATA__
=pod

=head1 DESCRIPTION

Ordinary 1.1

=begin nonpod

Data 2.1

=cut
Nonpod 1.0
Nonpod 1.0 Continued
=head1 Nonpod Header

Data 2.2

=end nonpod

=head1 Outer Header

Ordinary 1.2

=cut
Nonpod 2.0

=pod

Ordinary 1.3

=head2

Complete.

=cut
