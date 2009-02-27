package Angelos::Middleware::Profile;
use Angelos::Class;
extends 'HTTP::Engine::Middleware::Profile';

sub log {
    my ($self, $message) = @_;
    Angelos::Utils::context()->logger->info($message);
}

__END_OF_CLASS__

__END__

=head1 NAME

Angelos::Middleware::Profile - documentation is TODO

=head1 SYNOPSIS

=cut

