use strict;
use warnings;
package Pod::Elemental::Selectors;

use Moose::Autobox 0.10;

use Sub::Exporter -setup => {
  exports => [ qw(s_command) ],
};

sub s_command {
  my ($command) = @_;

  return sub {
    my $para = shift;
    return unless $para->does('Pod::Elemental::Command');
    return 1 unless defined $command;
    
    my $alts = ref $command ? $command : [ $command ];
    return $para->command eq $alts->any;
  }
}

1;
