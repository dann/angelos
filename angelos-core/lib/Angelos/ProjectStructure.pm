package Angelos::ProjectStructure;
use Angelos::Class;

has 'home' => (
    is  => 'rw',
    isa => 'Angelos::Home',
);

sub logger_config_file {
    my $self = shift;
    $self->home->path_to( 'conf', 'log.yaml' );
}

sub routes_config_file {
    my $self = shift;
    $self->home->path_to( 'conf', 'routes.pl' );
}

sub config_file {
    my ( $self, $environment ) = @_;
    my $extension = '.yaml';
    $environment ||= $self->environment;
    my $config_filename = $environment . $extension;
    $self->home->path_to( 'conf', 'environments', $config_filename ),;
}

sub environment {
    my $self = shift;
    my $environment;
    $environment ||= $ENV{ANGELOS_ENV};
    $environment ||= 'development' if $ENV{ANGELOS_DEBUG};
    $environment ||= 'production';
    $environment;
}

sub root_dir {
    my $self = shift;
    $self->home->path_to( 'share', 'root' );
}

sub templates_dir {
    my $self = shift;
    $self->home->path_to( 'share', 'root', 'templates' );
}

__END_OF_CLASS__

