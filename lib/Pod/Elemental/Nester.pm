package Pod::Elemental::Nester;
use Moose;
use Moose::Autobox;

use Pod::Elemental::Element;

my %RANK = do {
  my $i = 0;
  map { $_ => $i++ } qw(head1 head2 head3 head4 over item begin for);
};

sub can_recurse {
  my ($self, $element) = @_;
  return 1 if $element->command eq [ qw(over begin) ]->any;
  return 0;
}

sub rank_for {
  my ($self, $element) = @_;
  return $RANK{ $element->command };
}

sub nest_elements {
  my ($self, $elements) = @_;

  my $top = Pod::Elemental::Element->new({
    type     => 'command',
    command  => 'pod',
    content  => "\n",
  });

  my @stack  = $top;

  EVENT: while (my $element = $elements->shift) {
    # =cut?  Where we're going, we don't need =cut. -- rjbs, 2015-11-05
    next if $element->type eq 'command' and $element->command eq 'cut';

    if ($element->type ne 'command') {
      $stack[-1]->children->push($element);
      next EVENT;
    }

    if ($element->command eq 'begin') {
      # =begin/=end are treated like subdocuments; we're going to look ahead
      # for the balancing =end, then pass the whole set of elements to a new
      # nestification process -- rjbs, 2008-10-20
      my $level  = 1;
      my @subdoc;

      SUBEV: while ($level and my $next = $elements->shift) {
        if (
          $next->type eq 'command'
          and $next->command eq 'begin'
          and $next->content eq $element->content
        ) {
          $level++;
          push @subdoc, $next;
          next SUBEV;
        }

        if (
          $next->type eq 'command'
          and $next->command eq 'end'
          and $next->content eq $element->content
        ) {
          $level--;
          push @subdoc, $next if $level;
          next SUBEV;
        }

        push @subdoc, $next;
      }

      $element->children->push( $self->nest_elements(\@subdoc)->flatten );
      $stack[-1]->children->push( $element );
      next EVENT;
    }

    if ($element->command eq 'back') {
      pop @stack until !@stack or $stack[-1]->command eq 'over';
      Carp::croak "encountered =back without =over" unless @stack;
      pop @stack; # we want to be outside of the 
      next EVENT;
    }

    if ($element->command eq 'end') {
      Carp::croak "encountered =end outside matching =begin";
    }

    pop @stack until @stack == 1 or defined $self->rank_for($stack[-1]);

    my $rank        = $self->rank_for($element);
    my $parent_rank = $self->rank_for($stack[-1]) || 0;

    if (@stack > 1) {
      if (! $rank) {
        @stack = $top;
      } else {
        until (@stack == 1) {
          last if $self->rank_for($stack[-1]) < $rank;
          last if $self->can_recurse($element)
              and $element->command eq $stack[-1]->command;

          pop @stack;
        }
      }
    }

    $stack[-1]->children->push($element);
    @stack->push($element);
  }

  @$elements = $top->children->flatten;
  return $elements;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
