package Angelos::Script::Command::Console::Plugin::History;
use Mouse::Role;
use File::Slurp;
use Path::Class;
use File::HomeDir;

around 'run_loop' => sub {
    my $orig = shift;
    my ( $self, @args ) = @_;
    $self->read_history;
    $self->$orig(@args);
    $self->write_history;
};

sub _history_file {
    return file( File::HomeDir->my_home, '.angelos_history' )->stringify;
}

sub read_history {
    my $self = shift;
    my $term = $self->term;
    my $h    = _history_file;

    if ( $term->Features->{readHistory} ) {
        $term->ReadHistory($h);
    }
    elsif ( $term->Features->{setHistory} ) {
        if ( -e $h ) {
            my @h = File::Slurp::read_file($h);
            chomp @h;
            $term->SetHistory(@h);
        }
    }
    else {

        # warn "Your ReadLine doesn't support setHistory\n";
    }

}

sub write_history {
    my $self = shift;
    my $term = $self->term;
    my $h    = _history_file;

    if ( $term->Features->{writeHistory} ) {
        $term->WriteHistory($h);
    }
    elsif ( $term->Features->{getHistory} ) {
        my @h = map {"$_\n"} $term->GetHistory;
        File::Slurp::write_file( $h, @h );
    }
    else {

        # warn "Your ReadLine doesn't support getHistory\n";
    }
}

1;
