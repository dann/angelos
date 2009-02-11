package Angelos::Middleware::DebugRequest;
use HTTP::Engine::Middleware;
use Text::SimpleTable;

before_handle {
    my ( $c, $self, $req ) = @_;
    $self->report_request_info($req);
    $req;
};

sub report_request_info {
    my ( $self, $request ) = @_;
    $self->report_request_basic_info($request);
    $self->report_params($request);
}

sub report_params {
    my ( $self, $req ) = @_;
    if ( keys %{ $req->parameters } ) {
        my $t
            = Text::SimpleTable->new( [ 20, 'Parameter' ], [ 36, 'Value' ] );
        for my $key ( sort keys %{ $req->parameters } ) {
            my $param = $req->parameters->{$key};
            my $value = defined($param) ? $param : '';
            $t->row( $key,
                ref $value eq 'ARRAY' ? ( join ', ', @$value ) : $value );
        }
        my $message = "Parameters: \n" . $t->draw;
        $self->log( 'info', $message );
    }
}

sub report_request_basic_info {
    my ( $self, $req ) = @_;
    my $t = Text::SimpleTable->new(
        [ 40, 'Path' ],
        [ 8,  'Method' ],
        [ 30, 'Base' ]
    );
    $t->row( $req->path, $req->method, $req->base );
    my $message = "Matching Info:\n" . $t->draw;
    $self->log( 'info', $message );
}

__MIDDLEWARE__

__END__

=head1 NAME

HTTP::Engine::Middleware::DebugRequest - documentation is TODO

=head1 SYNOPSIS

    my $mw = HTTP::Engine::Middleware->new;
    $mw->install( 'HTTP::Engine::Middleware::DebugRequest' => {
        logger => sub {
            my($level, $msg) = @_;
            warn $mgs;
        },
    });
    HTTP::Engine->new(
        interface => {
            module => 'YourFavoriteInterfaceHere',
            request_handler => $mw->handler( \&handler ),
        }
    )->run();

=cut
