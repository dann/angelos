package Angelos::Dispatcher::Routes::Builder;
use Mouse;
use Angelos::Config;
use HTTP::Router;
use Angelos::Logger;
use Angelos::Exceptions;

sub build_from_config {
    my $self      = shift;
    my $conf_path = Angelos::Config->routes_config_path;
    Angelos::Exception->throw(
        message => "routes.pl doesn't exit: $conf_path" )
        unless -f $conf_path;
    $self->build($conf_path);
}

sub build {
    my ( $self, $conf ) = @_;
    my $content = $conf->slurp;
    my $router = eval $content;
    if ( my $e = $@ ) {
        Angelos::Exception->throw(
            message => "Can't load routes.pl: $conf. error: $e" );
    }
    my @routeset = $router->routeset;
    \@routeset;
}

__PACKAGE__->meta->make_immutable;

1;
