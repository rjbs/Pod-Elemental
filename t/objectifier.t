use strict;
use warnings;
use Test::More tests => 1;
use Test::Deep;

use Moose::Autobox;
use Pod::Eventual::Simple;
use Pod::Elemental::Objectifier;

my $events   = Pod::Eventual::Simple->read_file('t/eg/Simple.pm');
my $elements = Pod::Elemental::Objectifier->objectify_events($events);

my @want = (
  { type => 'Nonpod',  content => ignore()                                  },
  { type => 'Command', command => 'head1', content => "DESCRIPTION"         },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Text',    content => re(qr{^This is .+ that\?})                },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'synopsis', content => ""                 },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Text',    content => re(qr{^  use Test.+;$})                   },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'head2',  content => "Free Radical"       },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'head3',  content => "Subsumed Radical"   },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'over',   content => "4"                  },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'item',   content => re(qr{^\* nom.+st$}) },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'back',   content => ""                   },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'method', content => "none"               },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Text',    content => "Nope, there are no methods.",            },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'attr',   content => "also_none"          },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Text',    content => "None of these, either."                  },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'method', content => "i_lied"             },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Text',    content => "Ha!  Gotcha!"                            },
  { type => 'Blank',   content => "\n"                                      },
  { type => 'Command', command => 'cut',    content => ""                   },
  { type => 'Nonpod',  content => ignore()                                  },
);

my @got;
for my $elem (@$elements) {
  my $class = ref $elem;
  $class =~ s/^.+:://g;
  push @got, {
    type    => $class,
    content => $elem->content,
    ($elem->can('command') ? (command => $elem->command) : ()),
  };
}

cmp_deeply(
  \@got,
  \@want,
  "we get the right chunky content we wanted",
);
