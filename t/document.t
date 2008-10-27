use strict;
use warnings;
use Test::More tests => 1;
use Test::Deep;

use Moose::Autobox;
use Pod::Eventual::Simple;
use Pod::Elemental::Objectifier;
use Pod::Elemental::Nester;
use Pod::Elemental::Document;

my $events   = Pod::Eventual::Simple->read_file('t/eg/nested-begin.pod')
               ->grep(sub { $_->{type} ne 'nonpod' });
my $elements = Pod::Elemental::Objectifier->objectify_events($events);
my $document = Pod::Elemental::Document->new;

Pod::Elemental::Nester->nest_elements($elements);

$document->add_elements($elements);

my $str = do { local $/; <DATA> };
is($document->as_string, $str, 'we got what we expected');

__DATA__
=pod

=head1 DESCRIPTION

Foo.

=begin outer

=begin inner

=head1 Inner!

=over 

=item * one

=back

=begin inner

=head1 Another!

=end inner

=head2 Welcome to my Second Head

=end inner

=head3 Finalizing

=end outer

Baz.

=cut
