package Angelos::Dispatcher::Routes::Builder;
use Angelos::Class;
use HTTP::Router;
use Angelos::Exceptions;
use Angelos::Utils;

sub build_from_config {
    my $self = shift;

    my $conf_path = $self->_route_config;
    Angelos::Exception->throw(
        message => "routes.pl doesn't exit: $conf_path" )
        unless -f $conf_path;
    $self->build($conf_path);
}

sub build {
    my ( $self, $conf ) = @_;
    my $content = $conf->slurp;
    my $router  = eval $content; ##no critic
    if ( my $e = $@ ) {
        Angelos::Exception->throw(
            message => "Can't load routes.pl: $conf. error: $e" );
    }
    my @routeset = $router->routeset;
    \@routeset;
}

sub _route_config {
    Angelos::Utils::context->project_structure->routes_config_file_path;
}

__END_OF_CLASS__
