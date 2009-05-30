package Pod::Elemental::Nester::Pod5;
use Moose;
with 'Pod::Elemental::Nester';
# ABSTRACT: the default, minimal semantics of Perl5's pod element hierarchy

use Moose::Autobox;

use namespace::autoclean;

use Pod::Elemental::Document;
use Pod::Elemental::Element::Pod5::Data;
use Pod::Elemental::Element::Pod5::Ordinary;
use Pod::Elemental::Element::Pod5::Verbatim;

# TODO: handle the stupid verbatim-correction when inside non-colon-begin

sub _gen_class { "Pod::Elemental::Element::Generic::$_[1]" }
sub _class     { "Pod::Elemental::Element::Pod5::$_[1]" }

sub transform_document {
  my ($self, $document) = @_;

  my $new_doc = Pod::Elemental::Document->new;
  my @stack   = ($new_doc);

  my $nodes = $document->children;
  POS: for my $pos ($nodes->keys->flatten) {
    my $current = $nodes->[ $pos ];

    # Pod5 has three kinds of text: ordinary, verbatim, and data.
    if ($current->isa('Pod::Elemental::Element::Generic::Text')) {
      $current = $self->_xform_text($current, \@stack);
    }

    use Data::Dumper;
    # warn Dumper($new_doc->children);

    if (
          $stack[ -1 ]->does('Pod::Elemental::Node')
      and $stack[ -1 ]->children->length
    ) {
      my $last_para = $stack[ -1 ]->children->[ -1 ];

      if (
        ($last_para->isa( $self->_class('Data') )
          or $last_para->isa( $self->_class('Verbatim')))
        and (
          ($current->isa( $self->_class('Data') ) and
            $last_para->isa( $self->_class('Data')))
          or
          ($current->isa( $self->_class('Verbatim') ) and
            $last_para->isa( $self->_class('Verbatim')))
          or
          ($current->isa( $self->_gen_class('Blank') ) and (
               $last_para->isa( $self->_class('Data'))
            or $last_para->isa( $self->_class('Verbatim'))))
        )
      ) {
        warn "can combine";
        $last_para->content(
          $last_para->content . $current->content
      }
    }

    while (1) {
      # if (not @stack) {
        $stack[ -1 ]->children->push( $current );
        next POS;
      # }

      # collect data/verbatim 

      # my $ok = eval { $stack[ -1 ]->add_child($current); 1 };
      my $ok = eval { $document->children->push($current); 1 };
      next POS if $ok;
      
      my $error = $@;
      die $error unless eval { $error->isa('Pod::Elemental::Exception') };
      $self->__handle_exception($error);
    }
  }

  return $new_doc;
}

sub _xform_text {
  my ($self, $para, $stack) = @_;

  my $in_data = $stack->[0]->does('Pod::Elemental::FormatRegion')
             && ! $stack->[0]->is_pod;

  my $new_class = $in_data                   ? $self->_class('Data')
                : ($para->content =~ /\A\s/) ? $self->_class('Verbatim')
                :                              $self->_class('Ordinary');
  
  return $new_class->new({
    content    => $para->content,
    start_line => $para->start_line,
  });
}

sub __handle_exception { warn "EXCEPTION: $_[1]\n" }

1;
