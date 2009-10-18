#!perl
use strict;
use warnings;

# PURPOSE:
# show that begin/end are turned into regions with the correct properties

use Test::More tests => 4;

use Pod::Elemental;
use Pod::Elemental::Transformer::Pod5;

my $content  = do {
  local $/;
  open my $fh, '<', 't/eg/from-lol.pod' or die "can't read: $!";
  <$fh>;
};

my $doc = Pod::Elemental->read_string($content);

{
  my @regions = grep { (ref $_) =~ /Region/ } @{ $doc->children };
  is(@regions, 0, "there are no regions prior to Pod5 transform");
}

Pod::Elemental::Transformer::Pod5->new->transform_node($doc);

{
  my @regions = grep { (ref $_) =~ /Region/ } @{ $doc->children };
  is(@regions, 1, "there is one (top-level) region post transformation");

  my @subregions = grep { (ref $_) =~ /Region/ } @{ $regions[0]->children };
  is(@subregions, 1, "there is one (2nd-level) region post transformation");

  my @subsub = grep { (ref $_) =~ /Region/ } @{ $subregions[0]->children };
  is(@subsub, 0, "there are no (3rd-level) region post transformation");
}

