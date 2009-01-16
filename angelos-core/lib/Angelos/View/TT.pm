package Angelos::View::TT;
use Mouse;
use Template;
use Angelos::Home;
use Path::Class;
extends 'Angelos::View';

has 'INCLUDE_PATH'       => ( is       => 'rw', );
has 'TEMPLATE_EXTENSION' => ( +default => '.tt' );
has 'CONTENT_TYPE'       => ( +default => 'text/html' );

# TODO: Implement at _build_engine
# _build_providers
has 'PROVIDERS' => (
    is  => 'rw',
    isa => 'ArrayRef',
);

# TODO: Implement at _build_engine
has 'PRE_PROCESS' => (
    is  => 'rw',
    isa => 'Str',
);

# TODO: Implement at _build_engine
has 'WRAPPER' => (
    is  => 'rw',
    isa => 'Str',
);

# TODO: Implement at _build_engine
has 'TIMER' => (
    is  => 'rw',
    isa => 'Str',
);

no Mouse;

sub _build_engine {
    my $self = shift;
    my $include_path ||= $self->INCLUDE_PATH;
    $include_path    ||= $self->root;

    my $config = {
        EVAL_PERL    => 0,
        INCLUDE_PATH => $include_path,
    };

    Template->new(%$config);
}

sub _render {
    my ( $self, $c, $vars ) = @_;
    $self->engine->process( $c->stash->{template}, $vars, \my $out );
    if ( $self->engine->error ) {
        my $error
            = "Couldn't render template "
            . $c->stash->{template} . ": "
            . $self->engine->error;
        $c->log( level => 'error', message => $error );
    }
    $out;
}

__PACKAGE__->meta->make_immutable;

1;
