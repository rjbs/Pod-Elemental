use strict;
use warnings;
package Pod::Elemental::Selectors;

use Moose::Autobox 0.10;

use Sub::Exporter -setup => {
  exports => [ qw(s_blank s_flat s_node s_command) ],
};

sub s_blank {
  my $code = sub {
    my $para = shift;
    return $para->isa('Pod::Elemental::Element::Generic::Blank');
  };

  return @_ ? $code->(@_) : $code;
}

sub s_flat {
  my $code = sub {
    my $para = shift;
    return $para->does('Pod::Elemental::Flat');
  };

  return @_ ? $code->(@_) : $code;
}

sub s_node {
  my $code = sub {
    my $para = shift;
    return $para->does('Pod::Elemental::Node');
  };

  return @_ ? $code->(@_) : $code;
}

sub s_command {
  my $command = shift;

  my $code = sub {
    my $para = shift;
    return unless $para->does('Pod::Elemental::Command');
    return 1 unless defined $command;
    
    my $alts = ref $command ? $command : [ $command ];
    return $para->command eq $alts->any;
  };

  return @_ ? $code->(@_) : $code;
}

1;
