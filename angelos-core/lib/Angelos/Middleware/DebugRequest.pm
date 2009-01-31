package Angelos::Middleware::DebugRequest;
use HTTP::Engine::Middleware;
use Text::SimpleTable;

has 'logger' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_logger',
);

before_handle {
    my ( $c, $self, $req ) = @_;
    $self->report_request_info($req);
    $req;
};

# TODO
# if a logger is provided from HTTP::Engine::Middleware ,
# we don't need the implementation like below 
sub build_logger {
    if ( eval "require Log::Dispatch; require Log::Dispatch::Screen; 1" ) {
        my $dispatcher = Log::Dispatch->new;
        $dispatcher->add(
            Log::Dispatch::Screen->new(
                name      => 'screen',
                min_level => 'debug',
            )
        );
        return $dispatcher;
    }
    else {
        die 'Need to setup logger instance';
    }
}

sub report_request_info {
    my ( $self, $request ) = @_;
    $self->report_params($request);
    $self->report_matching_info($request);
}

sub report_params {
    my ( $self, $req ) = @_;
    for my $method (qw/params query_params body_params/) {
        if ( keys %{ $req->$method } ) {
            my $t = Text::SimpleTable->new( [ 35, 'Parameter' ],
                [ 36, 'Value' ] );
            for my $key ( sort keys %{ $req->$method } ) {
                my $param = $req->$method->{$key};
                my $value = defined($param) ? $param : '';
                $t->row( $key,
                    ref $value eq 'ARRAY' ? ( join ', ', @$value ) : $value );
            }
            my $message = "Parameters $method: \n" . $t->draw;
            $self->logger->log( level => 'info', message => $message );
        }
    }
}

sub report_matching_info {
    my ( $self, $req ) = @_;
    my $t = Text::SimpleTable->new(
        [ 40, 'Path' ],
        [ 8,  'Method' ],
        [ 30, 'Base' ]
    );
    $t->row( $req->path, $req->method, $req->base );
    my $message = "Matching Info:\n" . $t->draw;
    $self->logger->info($message);
}

__MIDDLEWARE__

__END__
