#!perl
use strict;
use warnings;

use Test::More tests => 2;

use Pod::Elemental::Element::Pod5::Region;
use Pod::Elemental::Element::Pod5::Ordinary;

my $for = Pod::Elemental::Element::Pod5::Region->new({
  format_name => 'test',
  is_pod      => 0,
  content     => "This is a test.\n",
});

my $for_expected = <<'END_FOR';
=for test This is a test.
END_FOR

is(
  $for->as_pod_string,
  $for_expected,
  "childless Region is =for",
);

my $begin = Pod::Elemental::Element::Pod5::Region->new({
  format_name => 'test',
  is_pod      => 0,
  content     => "This is a test.\n",
  children    => [
    Pod::Elemental::Element::Pod5::Ordinary->new({
      content => "Ordinary paragraph.\n",
    }),
  ],
});

my $begin_expected = <<'END_FOR';
=begin test This is a test.

Ordinary paragraph.

=end test
END_FOR

is(
  $begin->as_pod_string,
  $begin_expected,
  "childed Region is =begin/=end",
);
