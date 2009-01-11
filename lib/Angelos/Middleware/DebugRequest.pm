package Angelos::Middleware::DebugRequest;
use Mouse;
use Text::SimpleTable;
use Angelos::Logger;
extends 'Angelos::Middleware';

no Mouse;

sub wrap {
    my ( $self, $next ) = @_;

    sub {
        my $req = shift;
        my $res = $next->($req);
        $self->report_request($req);
        return $res;
    }
}

sub report_request {
    my ( $self, $request ) = @_;
    $self->report_query_parameters($request);
    $self->report_body_parameters($request);
    $self->report_matching_info($request);
}

sub report_query_parameters {
    my ( $self, $req ) = @_;
    if ( keys %{ $req->query_parameters } ) {
        my $t
            = Text::SimpleTable->new( [ 35, 'Parameter' ], [ 36, 'Value' ] );
        for my $key ( sort keys %{ $req->query_parameters } ) {
            my $param = $req->query_parameters->{$key};
            my $value = defined($param) ? $param : '';
            $t->row( $key,
                ref $value eq 'ARRAY' ? ( join ', ', @$value ) : $value );
        }
        my $message = "Query Parameters are:\n" . $t->draw;
        $self->log_message($message);
    }
}

sub report_body_parameters {
    my ( $self, $req ) = @_;
    if ( keys %{ $req->body_parameters } ) {
        my $t
            = Text::SimpleTable->new( [ 35, 'Parameter' ], [ 36, 'Value' ] );
        for my $key ( sort keys %{ $req->body_parameters } ) {
            my $param = $req->body_parameters->{$key};
            my $value = defined($param) ? $param : '';
            $t->row( $key,
                ref $value eq 'ARRAY' ? ( join ', ', @$value ) : $value );
        }
        my $message = "Body Parameters are:\n" . $t->draw;
        $self->log_message($message);
    }
}

sub report_matching_info {
    my ( $self, $req ) = @_;
    my $t = Text::SimpleTable->new( [ 40, 'Path' ], [ 8, 'Method' ], [ 30, 'Base' ] );
    $t->row( $req->path, $req->method , $req->base);
    my $message = "Matching Info:\n" . $t->draw;
    $self->log_message($message);
}

__PACKAGE__->meta->make_immutable;

1;
