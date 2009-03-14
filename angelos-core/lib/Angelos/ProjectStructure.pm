package Angelos::ProjectStructure;
use Angelos::Class;
use Path::Class;

has 'home' => (
    is  => 'rw',
    isa => 'Angelos::Home',
);

sub conf_dir {
    my $self = shift;
    $self->home->path_to('conf');
}

sub logger_config_file_path {
    my ( $self, $environment ) = @_;
    $environment ||= $self->environment;
    file( $self->conf_dir, 'environments', $environment, 'log.yaml' );
}

sub routes_config_file_path {
    my $self = shift;
    file( $self->conf_dir, 'routes.pl' );
}

sub config_file_path {
    my ( $self, $environment ) = @_;
    $environment ||= $self->environment;
    file( $self->conf_dir, 'environments', $environment, 'config.yaml' );
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

sub po_dir {
    my $self = shift;
    $self->home->path_to( 'share', 'po' );
}

sub templates_dir {
    my $self = shift;
    dir( $self->root_dir, 'views' );
}

sub layouts_dir {
    my $self = shift;
    dir( $self->templates_dir, 'layouts');
}

sub db_dir {
    my $self = shift;
    dir( 'db' );
}

__END_OF_CLASS__

__END__

