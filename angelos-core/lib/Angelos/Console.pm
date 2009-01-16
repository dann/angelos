package Angelos::Console;
use Mouse;
use Term::ReadLine;
use Devel::EvalContext;
with 'Angelos::Class::Pluggable';

has 'term' => (
    is       => 'rw',
    required => 1,
    default  => sub { Term::ReadLine->new('Angelos') }
);

has 'prompt' => (
    is       => 'rw',
    required => 1,
    default  => sub {'angelos> '}
);

has 'out_fh' => (
    is       => 'rw',
    required => 1,
    lazy     => 1,
    default  => sub { shift->term->OUT || \*STDOUT; }
);

no Mouse;

sub run {
    my ($self) = @_;

    $self->setup_plugins;
    $self->show_banner;

    while ( $self->run_once_safely ) {

        # keep looping
    }
}

sub setup_plugins {
    my $self = shift;
    $self->load_plugin('History');
}

sub show_banner {
    print "Welcome to Angelos Console  (c) 2008 Dann.\n";
    print "\n";
}

sub run_once_safely {
    my ( $self, @args ) = @_;

    my $ret = eval { $self->run_once(@args) };

    if ($@) {
        my $error = $@;
        eval { $self->print("Error! - $error\n"); };
        return 1;
    }
    else {
        return $ret;
    }
}

sub run_once {
    my ($self) = @_;

    my $line = $self->read;
    return unless defined($line);    # undefined value == EOF

    my @ret = $self->eval($line);

    $self->print(@ret);

    return 1;
}

sub read {
    my ($self) = @_;
    return $self->term->readline( $self->prompt );
}

sub eval {
    my ( $self, $line ) = @_;
    my $compiled = $self->compile($line);
    return $compiled
        unless defined($compiled);
    return $self->execute($compiled);
}

sub compile {
    my ( $self, $line ) = @_;
    $line;
}

sub execute {
    my ( $self, $compiled ) = @_;
    my $cxt = Devel::EvalContext->new;
    my $res = $cxt->run($compiled);
    return $res unless $@;
}

sub print {
    my ( $self, @ret ) = @_;
    my $fh = $self->out_fh;
    no warnings 'uninitialized';
    print $fh "@ret";
    print $fh "\n" if $self->term->ReadLine =~ /Gnu/;
}

__PACKAGE__->meta->make_immutable;

1;
