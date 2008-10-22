use strict;
use warnings;
use Test::More tests => 1;
use Test::Deep;

use Moose::Autobox;
use Pod::Eventual::Simple;
use Pod::Elemental::Objectifier;

my $events   = Pod::Eventual::Simple->read_file('t/eg/Simple.pm');
my $elements = Pod::Elemental::Objectifier->objectify_events($events);

my $want = [
  { type => 'command',  command => 'head1', content => "DESCRIPTION" },
  { type => 'text',     content => re(qr{^This is .+ that\?})     },
  { type => 'command',  command => 'synopsis', content => ""      },
  { type => 'verbatim', content => re(qr{^  use Test.+;$})          },
  { type => 'command',  command => 'head2', content => "Free Radical" },
  { type => 'command',  command => 'head3', content => "Subsumed Radical" },
  { type => 'command',  command => 'over',  content => "4" },
  { type => 'command',  command => 'item',  content => re(qr{^\* nom.+st$}) },
  { type => 'command',  command => 'back',  content => "" },
  { type => 'command',  command => 'method',  content => "none"      },
  { type => 'text',     content => "Nope, there are no methods.",    },
  { type => 'command',  command => 'attr',    content => "also_none" },
  { type => 'text',     content => "None of these, either."          },
  { type => 'command',  command => 'method',  content => "i_lied"    },
  { type => 'text',     content => "Ha!  Gotcha!"                    },
  { type => 'command',  command => 'cut',     content => ""          },
];

cmp_deeply(
  $elements->grep(sub { $_->{type} ne 'nonpod' })->map(sub { $_->as_hash }),
  $want,
  "we get the right chunky content we wanted",
);
