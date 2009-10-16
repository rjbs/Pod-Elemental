#!perl
use strict;
use warnings;

# PURPOSE:
# sequences of text..(blank|text)+..text should be collapsed into text
# sequences of data..(blank|data)+..data should be collapsed into data

use Test::More;

