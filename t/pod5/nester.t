use strict;
use warnings;
use Test::More tests => 1;
use Test::Deep;

use Moose::Autobox;
use Pod::Eventual::Simple;
use Pod::Elemental::Objectifier;
use Pod::Elemental::Transformer::Pod5;

my $events   = Pod::Eventual::Simple->read_file('t/eg/Simple.pm');
my $elements = Pod::Elemental::Objectifier->objectify_events($events);
my $document = Pod::Elemental::Document->new({ children => $elements });

my $pod5_doc = Pod::Elemental::Transformer::Pod5->transform_document($document);

# use YAML::XS;
# warn Dump($pod5_doc->children);

ok(1);
