use strict;
use warnings;
package Pod::Elemental::Selectors;
# ABSTRACT: predicates for selecting elements

=head1 OVERVIEW

Pod::Elemental::Selectors provides a number of routines to check for
Pod::Elemental paragraphs with given qualities.

=head1 SELECTORS

Selectors are predicates:  they examine paragraphs and return either true or
false.  All the selectors have (by default) names like: C<s_whatever>.  They
expect zero or more parameters to affect the selection.  If these parameters
are given, but no paragraph, a callback will be returned that will expect a
paragraph.  If a paragraph is given, the selector will return immediately.

For example, the C<s_command> selector expects a parameter that can be the name
of the command desired.  Both of the following uses are valid:

  # create and use a callback:

  my $selector = s_command('head1');
  my @headers  = grep { $selector->($_) } @paragraphs;

  # just check a paragraph right now:

  if ( s_command('head1', $paragraph) ) { ... }

The selectors can be imported individually or as the C<-all> group, and can be
renamed with L<Sub::Exporter> features.  (Selectors cannot I<yet> be curried by
Sub::Exporter.)

=cut

use Moose::Autobox 0.10;

use Sub::Exporter -setup => {
  exports => [ qw(s_blank s_flat s_node s_command) ],
};

=head2 s_blank

  my $callback = s_blank;

  if( s_blank($para) ) { ... }

C<s_blank> tests whether a paragraph is a Generic::Blank element.

=cut

sub s_blank {
  my $code = sub {
    my $para = shift;
    return $para->isa('Pod::Elemental::Element::Generic::Blank');
  };

  return @_ ? $code->(@_) : $code;
}

=head2 s_flat

  my $callback = s_flat;

  if( s_flat($para) ) { ... }

C<s_flat> tests whether a paragraph does Pod::Elemental::Flat -- in other
words, is content-only.

=cut

sub s_flat {
  my $code = sub {
    my $para = shift;
    return $para->does('Pod::Elemental::Flat');
  };

  return @_ ? $code->(@_) : $code;
}

=head2 s_node

  my $callback = s_node;

  if( s_node($para) ) { ... }

C<s_node> tests whether a paragraph does Pod::Elemental::Node -- in other
words, whether it may have children.

=cut

sub s_node {
  my $code = sub {
    my $para = shift;
    return $para->does('Pod::Elemental::Node');
  };

  return @_ ? $code->(@_) : $code;
}

=head2 s_command

  my $callback = s_command;
  my $callback = s_command( $command_name);
  my $callback = s_command(\@command_names);

  if( s_command(undef, \$para) ) { ... }

  if( s_command( $command_name,  \$para) ) { ... }
  if( s_command(\@command_names, \$para) ) { ... }

C<s_command> tests whether a paragraph does Pod::Elemental::Command.  If a
command name (or a reference to an array of command names) is given, the tested
paragraph's command must match one of the given command names.

=cut

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
