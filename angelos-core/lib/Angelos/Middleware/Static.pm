package Angelos::Middleware::Static;
use HTTP::Engine::Middleware;
use HTTP::Engine::Response;
use MIME::Types;
use Path::Class;
use Angelos::Home;

with 'Angelos::Class::HomeAware';

has 'types' => (
    is      => 'rw',
    default => sub {
        MIME::Types->new;
    }
);

has 'prefix' => (
    is      => 'rw',
    default => 'static',
);

has 'root' => (
    is      => 'rw',
    lazy    => 1,
    builder => 'build_root',
);

sub build_root {
    my $self = shift;
    $self->home->path_to( 'share', 'root' );
}

before_handle {
    my ( $c, $self, $req ) = @_;

    my $path = $req->path;
    if ( $self->is_static_file($path) ) {
        my $full_path = file( $self->root, $path );
        return $self->serve_static($full_path);
    }
    else {
        $req;
    }
};

sub is_static_file {
    my ( $self, $path ) = @_;

    if ( my $prefix = $self->prefix ) {
        return 0 unless $path =~ /^\/$prefix.*/;
    }

    my $ext       = $self->_extract_extension($path);
    my $type      = $self->_extension_to_type($ext) || 'text/plain';
    my $full_path = file( $self->root, $path );

    if ( -f $full_path ) {
        return 1;
    }
    else {
        return 0;
    }
}

sub serve_static {
    my $self      = shift;
    my $full_path = shift;
    my $type      = $self->_extension_to_type($full_path);
    my $stat      = $full_path->stat;

    my $res = HTTP::Engine::Response->new;
    $res->header( 'Content-Type'   => $type );
    $res->header( 'Content-Length' => $stat->size );
    $res->header( 'Last-Modified'  => $stat->mtime );

    my $fh = $full_path->openr;
    if ( defined $fh ) {
        binmode $fh;
        $res->code(200);
        $res->body($fh);
    }
    else {
        die "Unable to open $full_path for reading";
    }
    $res;
}

sub _extract_extension {
    my ( $self, $path ) = @_;
    $path =~ /\.(\w+)$/;
    my $ext = $1;
    $ext;
}

sub _extension_to_type {
    my ( $self, $full_path ) = @_;
    my $type;
    if ( $full_path =~ /.*\.(\S{1,})$/xms ) {
        my $ext = $1;
        $type = $self->types->mimeTypeOf($ext);
    }
    $type ||= 'text/plain';
    $type;
}

__MIDDLEWARE__

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 CONTRIBUTORS

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
