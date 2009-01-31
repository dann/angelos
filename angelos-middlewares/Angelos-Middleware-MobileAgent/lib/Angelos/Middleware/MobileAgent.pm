package Angelos::Middleware::MobileAgent;
use HTTP::Engine::Middleware;
use HTTP::MobileAgent;

BEGIN {
    ## no critic.
    sub HTTP::MobileAgent::can_display_utf8 {
        my $self = shift;
        if (   $self->is_non_mobile
            || ( $self->is_vodafone && $self->is_type_3gc )
            || $self->xhtml_compliant )
        {
            return 1;
        }
        else {
            return 0;
        }
    }

    ## no critic.
    sub HTTP::MobileAgent::encoding {
        my $self = shift;
        $self->can_display_utf8() ? 'utf-8' : 'cp932';
    }
}

middleware_method 'mobile_attribute' => sub {
    my $self = shift;
    $self->{mobile_agent} ||= HTTP::MobileAgent->new( $self->headers );
};

__MIDDLEWARE__

__END__

=head1 NAME

Angelos::Middleware::MobileAgent -

=head1 SYNOPSIS

  use Angelos::Middleware::MobileAgent;

=head1 DESCRIPTION

Angelos::Middleware::MobileAgent is

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
