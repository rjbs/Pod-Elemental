#!perl
use strict;
use warnings;

use Test::More 'no_plan';

my $flat_lol = [
  [ '=head1' => "This is a head." ],
  [ '=head2' => "This is a subhead." ],
  [ (undef)  => "Ordinary 1"  ],
  [ (undef)  => "Ordinary 2"  ],
  [ '=begin' => ':pod_region' ],
    [ (undef)  => "Ordinary 3"  ],
    [ (undef)  => "Ordinary 4"  ],
    [ '=head1' => 'This is a head.' ],
    [ 'begin'  => 'nonpod_region' ],
      [ (undef)  => "Data 1"  ],
      [ (undef)  => "Data 2"  ],
      [ (undef)  => "Data 3"  ],
    [ 'end'    => ':pod_region'   ],
  [ 'end'    => 'nonpod_region' ],
];

my $nested_lol = [
  [ '=head1' => "This is a head."    ],
  [ '=head2' => "This is a subhead." ],
  [ (undef)  => "Ordinary 1", { class => 'Pod5::Ordinary' } ],
  [ (undef)  => "Ordinary 2", { class => 'Pod5::Ordinary' } ],
  [ ':pod_region' =>
    [ (undef)  => "Ordinary 3", { class => 'Pod5::Ordinary' } ],
    [ (undef)  => "Ordinary 4", { class => 'Pod5::Ordinary' } ],
    [ '=head1' => 'This is a head.' ],
    [ nonpod_region =>
      [ (undef)  => "Data 1", { class => 'Pod5::Data' }],
      [ (undef)  => "Data 2", { class => 'Pod5::Data' }],
      [ (undef)  => "Data 3", { class => 'Pod5::Data' } ],
    ],
  ],
];
