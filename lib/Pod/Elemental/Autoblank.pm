package Pod::Elemental::Autoblank;
# ABSTRACT: a paragraph that always displays an extra blank line in Pod form

use namespace::autoclean;
use Moose::Role;

=head1 OVERVIEW

This role exists primarily to simplify elements produced by the Pod5
transformer.  Any element with this role composed into it will append an extra
newline to the normally generated response to the C<as_pod_string> method.

That's it!

=cut

around as_pod_string => sub {
  my ($orig, $self, @arg) = @_;
  my $str = $self->$orig(@arg);
  "$str\n\n";
};

1;
