package Pod::Elemental::Transformer::Pod5;
use Moose;
with 'Pod::Elemental::Transformer';
# ABSTRACT: the default, minimal semantics of Perl5's pod element hierarchy

=head1 SYNOPSIS

  Pod::Elemental::Transformer::Pod5->new->transform_node($pod_elem_document);

...and that's it.

=head1 OVERVIEW

The Pod5 transformer is meant to be used to convert the result of a "stock"
Pod::Elemental::Document into something simpler to work with.  It assumes that
the document conforms more or less to the convetions laid out in L<perlpod> and
L<perlpodspec>.  It is not very strict, and makes very few assumptions,
described here:

=over 4

=item * =begin/=end and =for enclose or produce regions within the document

=item * regions are associated with format names; format names that begin with a colon enclose more pod-like content

=item * regions nest strictly; all inner regions must end before outer regions

=item * paragraphs in non-pod regions are "data" paragraphs

=item * non-data paragraphs that start with spaces are "verbatim" paragraphs

=item * groups of data or verbatim paragraphs can be consolodated

=back

Further, all elements are replaced with equivalent elements that perform the
L<Pod::Elemental::Autoblank> role, so all "blank" events can be removed form
the tree and ignored.

=head1 CONFIGURATION

None.  For now, it just does the same thing every time with no configuration or
options.

=cut

use Moose::Autobox 0.10;

use namespace::autoclean;

use Pod::Elemental::Document;
use Pod::Elemental::Element::Pod5::Command;
use Pod::Elemental::Element::Pod5::Data;
use Pod::Elemental::Element::Pod5::Nonpod;
use Pod::Elemental::Element::Pod5::Ordinary;
use Pod::Elemental::Element::Pod5::Verbatim;
use Pod::Elemental::Element::Pod5::Region;

use Pod::Elemental::Selectors -all;

sub _gen_class { "Pod::Elemental::Element::Generic::$_[1]" }
sub _class     { "Pod::Elemental::Element::Pod5::$_[1]" }

sub _region_para_parts {
  my ($self, $para) = @_;

  my ($colon, $target, $content, $nl) = $para->content =~ m/
    \A
    (:)?
    (\S+)
    (?:\s+(.+))?
    (\s+)\z
  /x;

  confess("=begin cannot be parsed") unless defined $target;

  $colon   ||= '';
  $content ||= '';

  return ($colon, $target, "$content$nl");
}

sub __extract_region {
  my ($self, $name, $in_paras) = @_;

  my %nest = ($name => 1);
  my @region_paras;

  REGION_PARA: while (my $region_para = shift @$in_paras) {
    if (s_command([ qw(begin end) ], $region_para)) {
      my ($r_colon, $r_target) = $self->_region_para_parts($region_para);

      for ($nest{ "$r_colon$r_target" }) {
        $_ += $region_para->command eq 'begin' ? 1 : -1;

        confess("=end $r_colon$r_target without matching begin") if $_ < 0;

        last REGION_PARA if !$_ and "$r_colon$r_target" eq $name;
      }
    }

    @region_paras->push($region_para);
  };

  return \@region_paras;
}

sub _upgrade_nonpod {
  my ($self, $in_paras) = @_;

  $in_paras->each(sub {
    my ($i, $para) = @_;
    return unless $para->isa( $self->_gen_class('Nonpod') );
    $in_paras->[ $i ] = $self->_class('Nonpod')->new({
      content => $para->content,
    });
  });
}

sub _collect_regions {
  my ($self, $in_paras) = @_;

  my @out_paras;

  my $s_region = s_command([ qw(begin for) ]);
  my $region_class = $self->_class('Region');

  PARA: while (my $para = $in_paras->shift) {
    @out_paras->push($para), next PARA unless $s_region->($para);

    if ($para->command eq 'for') {
      # factor out (for vertical space if nothing else) -- rjbs, 2009-10-20
      my ($colon, $target, $content) = $self->_region_para_parts($para);

      my $region = $region_class->new({
        children    => [
          $self->_gen_class('Text')->new({ content => $content }),
        ],
        format_name => $target,
        is_pod      => $colon ? 1 : 0,
        content     => "\n",
      });

      @out_paras->push($region);
      next PARA;
    }

    my ($colon, $target, $content) = $self->_region_para_parts($para);

    my $region_paras = $self->__extract_region("$colon$target", $in_paras);

    $region_paras->shift while s_blank($region_paras->[0]);
    $region_paras->pop   while s_blank($region_paras->[-1]);

    my $region = $region_class->new({
      children    => $self->_collect_regions($region_paras),
      format_name => $target,
      is_pod      => $colon ? 1 : 0,
      content     => $content,
    });

    @out_paras->push($region);
  }

  @$in_paras = @out_paras;

  return $in_paras;
}

sub _strip_markers {
  my ($self, $in_paras) = @_;

  @$in_paras = grep { ! s_command([ qw(cut pod) ], $_) } @$in_paras;
  $in_paras->shift while @$in_paras and s_blank($in_paras->[0]);
}

sub _autotype_paras {
  my ($self, $paras, $is_pod) = @_;

  $paras->each(sub {
    my ($i, $elem) = @_;
    
    if ($elem->isa( $self->_gen_class('Text') )) {
      my $class = $is_pod
                ? $elem->content =~ /\A\s/
                  ? $self->_class('Verbatim')
                  : $self->_class('Ordinary')
                : $self->_class('Data');

      $paras->[ $i ] = $class->new({ content => $elem->content });
    }

    if ($elem->isa( $self->_class('Region') )) {
      $self->_autotype_paras( $elem->children, $elem->is_pod );
    }

    if ($elem->isa( $self->_gen_class('Command') )) {
      $paras->[ $i ] = $self->_class('Command')->new({
        command => $elem->command,
        content => $elem->content,
      });
    }
  });
}

sub __text_class {
  my ($self, $para) = @_;

  for my $type (qw(Verbatim Data)) {
    my $class = $self->_class($type);
    return $class if $para->isa($class);
  }

  return;
}

sub _collect_runs {
  my ($self, $paras) = @_;

  $paras->grep(sub { $_->isa( $self->_class('Region') ) })->each_value(sub {
    $self->_collect_runs($_->children) 
  });

  PASS: for my $start (0 .. $#$paras) {
    last PASS if $#$paras - $start < 2; # we need X..Blank..X at minimum

    my $class = $self->__text_class( $paras->[ $start ] );
    next PASS unless $class;

    my @to_collect = ($start);
    NEXT: for my $next ($start+1 .. $#$paras) {
      if (
        $paras->[ $next ]->isa($class)
        or
        s_blank($paras->[ $next ])
      ) {
        push @to_collect, $next;
        next NEXT;
      }
      
      last NEXT;
    }

    pop @to_collect while s_blank($paras->[ $to_collect[ -1 ] ]);

    next PASS unless @to_collect >= 3;

    my $new_content = $paras
                    ->slice(\@to_collect)
                    ->map(sub { $_->content })
                    ->join(q{});

    splice @$paras, $start, scalar(@to_collect), $class->new({
      content => $new_content,
    });

    redo PASS;
  }

  @$paras = grep { not s_blank($_) } @$paras;

  # I really don't feel bad about rewriting in place by the time we get here.
  # These are private methods, and I know the consequence of calling them.
  # Nobody else should be.  So there.  -- rjbs, 2009-10-17
  return $paras;
}

sub transform_node {
  my ($self, $node) = @_;

  $self->_strip_markers($node->children);
  $self->_upgrade_nonpod($node->children);
  $self->_collect_regions($node->children);
  $self->_autotype_paras($node->children, 1);
  $self->_collect_runs($node->children);

  return $node;
}

1;
