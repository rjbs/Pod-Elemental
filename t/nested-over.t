use strict;
use warnings;
use Test::More;
plan skip_all => 'Pod5 transformer is still under construction';
plan tests => 1;
use Test::Deep;

use Moose::Autobox;
use Pod::Eventual::Simple;
use Pod::Elemental::Document;
use Pod::Elemental::Objectifier;
use Pod::Elemental::Transformer::Pod5;

my $events   = Pod::Eventual::Simple->read_file('t/eg/nested-over.pod')
               ->grep(sub { $_->{type} ne 'nonpod' });
my $elements = Pod::Elemental::Objectifier->objectify_events($events);
my $document = Pod::Elemental::Document->new({ children => $elements });

$document = Pod::Elemental::Transformer::Pod5->transform_document($document);

my $want = [
  {
    cmd('head1'),
    content  => "DESCRIPTION",
    children => [
      { txt("Foo.") },
      {
        cmd('over'),
        content  => "",
        children => [
          { cmd('item'), content => "* one" },
          {
            cmd('over'),
            content  => "",
            children => [
              { cmd('item'), content => "* oneone" },
              { cmd('item'), content => "* twotwo" },
            ]
          },
          { cmd('item'), content => "* two" },
        ]
      },

      {
        cmd('head2'),
        content  => "Sub-Description",
        children => [ { txt("Bar.") } ],
      },
    ],
  },
  {
    cmd('head1'),
    content => "Final",
    children => [ { txt("Baz.") } ],
  },
];

cmp_deeply(
  [ map { {%$_} } @$elements ],
  $want,
  'nested =over is not a problem'
);

sub cmd { return(type => 'command', command => $_[0]) }
sub txt { return(type => 'text',    content => $_[0]) }
