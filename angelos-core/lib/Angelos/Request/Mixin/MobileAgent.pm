package Angelos::Request::Mixin::MobileAgent;
use Angelos::Class;
use HTTP::MobileAgent;
extends 'Angelos::Request::Mixin';

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

sub SETUP {
    my $self = shift;
    $self->install_method(
        mobile_agent => sub {
            my $self = shift;
            $self->{mobile_agent}
                ||= HTTP::MobileAgent->new( $self->headers );
        }
    );
}

__END_OF_CLASS__
