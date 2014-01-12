package Pod::Elemental::Command;
# ABSTRACT: a =command paragraph

use Moose::Role 0.90;
with 'Pod::Elemental::Paragraph' => { -excludes => [ 'as_pod_string' ] };

=head1 OVERVIEW

This is a role to be included by paragraph classes that represent Pod commands.
It defines C<as_pod_string> and C<as_debug_string> methods.  Most code looking
for commands will check for the inclusion of this role, so be sure to use it
even if you override the provided methods.  Classes implementing this role must
also provide a C<command> method.  Generally this method will implemented by
an attribute, but this is not necessary.

=cut

use Moose::Autobox;

requires 'command';

sub as_pod_string {
  my ($self) = @_;

  my $content = $self->content;

  sprintf "=%s%s", $self->command, ($content =~ /\S/ ? " $content" : $content);
}

sub as_debug_string {
  my ($self) = @_;
  my $str = $self->_summarize_string($self->content);
  return sprintf '=%s %s', $self->command, $str;
}

1;
