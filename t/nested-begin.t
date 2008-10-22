use strict;
use warnings;
use Test::More tests => 1;
use Test::Deep;

use Moose::Autobox;
use Pod::Eventual::Simple;
use Pod::Elemental::Objectifier;
use Pod::Elemental::Nester;

my $events   = Pod::Eventual::Simple->read_file('t/eg/nested-begin.pod')
               ->grep(sub { $_->{type} ne 'nonpod' });
my $elements = Pod::Elemental::Objectifier->objectify_events($events);

Pod::Elemental::Nester->nest_elements($elements);

my $want = [
  {
    cmd('head1'),
    content  => "DESCRIPTION",
    children => [
      { txt("Foo.") },
      {
        cmd('begin'),
        content  => "outer",
        children => [
          {
            cmd('begin'),
            content  => "inner",
            children => [
              {
                cmd('head1'),
                content  => "Inner!",
                children => [
                  {
                    cmd('over'),
                    content  => "",
                    children => [ { cmd('item'), content => "* one" } ],
                  },
                  {
                    cmd('begin'),
                    content => "inner",
                    children => [ { cmd('head1'), content => "Another!" } ],
                  },
                  {
                    cmd('head2'),
                    content => "Welcome to my Second Head",
                  },
                ],
              },
            ],
          },
          {
            cmd('head3'),
            content => "Finalizing",
          },
        ],
      },
      { txt("Baz.") },
    ],
  },
];

cmp_deeply(
  [ map {$_->as_hash} @$elements ],
  $want,
  'nested =begins are not a problem'
);

# print join "\n", map { $_->as_debug_string } @$elements;

sub cmd { return(type => 'command', command => $_[0]) }
sub txt { return(type => 'text',    content => $_[0]) }
