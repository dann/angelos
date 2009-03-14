package Angelos::View::TT;
use Angelos::Class;
use Template;
use Path::Class;
use Angelos::Registrar;
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
    builder => 'build_wrapper',
);

# TODO: Implement at _build_engine
has 'TIMER' => (
    is  => 'rw',
    isa => 'Str',
);

has 'EVAL_PERL' => (
    is => 'rw',
    default => 0,
);

has 'ENCODING' => (
    is      => 'rw',
    default => 'utf8',
);

has 'FILTERS' => (
    is      => 'rw',
    builder => 'build_filters',
    lazy => 1,
);

sub build_wrapper {
    my $self = shift;
    file($self->context->project_structure->layouts_dir, 'application.tt');
}

sub context {
    Angelos::Registrar::context();
}

sub build_filters {
    # load filters 
    die 'Implement me';
}

sub _build_engine {
    my $self = shift;
    my $include_path ||= $self->INCLUDE_PATH;
    $include_path    ||= $self->root;

    my $config = {
        EVAL_PERL    => $self->EVAL_PERL,
        ENCODING=> $self->ENCODING,
#        FILTERS => $self->FILTERS,
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
        $c->logger->error($error);
    }
    $out;
}

__END_OF_CLASS__

