package TestApp::Web::Controller::Dbic;
use Angelos::Class;
use TestApp::Service::Artist;
extends 'Angelos::Controller';

has 'artist' => (
    is => 'rw',
    default => sub {
        TestApp::Service::Artist->new;
    },
);

sub find {
    my ( $self, $params ) = @_;
    my $artist = $self->artist->find(1);
    use Data::Dumper;
    warn Dumper $artist;
}

sub find_multi {
    my ( $self, $params ) = @_;
    my @artists = $self->artist->find_multi(1, 2);
    use Data::Dumper;
    warn Dumper @artists;
}



sub delete_artist {

}

__END_OF_CLASS__
