use strict;
use warnings;
use Test::More tests => 1;
use Test::Deep;

use Moose::Autobox;
use Pod::Eventual::Simple;
use Pod::Elemental::Objectifier;
use Pod::Elemental::Nester;

my $events   = Pod::Eventual::Simple->read_file('t/eg/Simple.pm')
               ->grep(sub { $_->{type} ne 'nonpod' });
my $elements = Pod::Elemental::Objectifier->objectify_events($events);

Pod::Elemental::Nester->nest_elements($elements);

my $want = [
  {
    cmd('head1'),
    content  => "DESCRIPTION",
    children => [ { txt( re(qr{^This is .+ that\?}) ) } ],
  },

  {
    cmd('synopsis'),
    content  => "",
    children => [ { type => 'verbatim', content => re(qr{^  use Test.+;$}) } ]
  },

  {
    cmd('head2'),
    content => "Free Radical",
    children => [
      {
        cmd('head3'),
        content => "Subsumed Radical",
        children => [
          {
            cmd('over'),
            content => "4",
            children => [ { cmd('item'), content => re(qr{^\* nom.+st}) } ],
  }, ], } ], },

  {
    cmd('method'),
    content => "none",
    children => [ { txt("Nope, there are no methods.") } ],
  },

  {
    cmd('attr'),
    content  => "also_none",
    children => [ { txt("None of these, either.") } ],
  },

  {
    cmd('method'),
    content  => "i_lied",
    children => [ { txt("Ha!  Gotcha!") } ],
  },
];

cmp_deeply(
  [ map {$_->as_hash} @$elements ],
  $want,
  "we get the right chunky content we wanted",
);

sub cmd { return(type => 'command', command => $_[0]) }
sub txt { return(type => 'text',    content => $_[0]) }
