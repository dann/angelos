package Angelos::Script::Command::Console;
use Mouse;
use base qw(Angelos::Script::Command);
use Term::ReadLine;
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

=head1 NAME

Angelos::Script::Command::Console - A console for your Angelos application

=head1 DESCRIPTION

This script aims for developing purpose (or maintaining, if possible).
With this script, you can say something like this to diagnose your
application:

    % bin/angelos console
    angelos> print 'Hello';

=head1 METHODS

=cut

sub opt_spec {
    return ();
}

=head2 run()

Creates a new console process.

=cut

sub run {
    my $self = shift;
    $self->setup_plugins;
    $self->show_banner;
    $self->run_loop;
}

sub setup_plugins {
    my $self = shift;
    $self->load_plugin('History');
}

sub run_loop {
    my ($self) = @_;
    while ( $self->run_once_safely ) {

        # keep looping
    }
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

    my @ret = $self->formatted_eval($line);

    $self->print(@ret);

    return 1;
}

sub formatted_eval {
    my ( $self, @args ) = @_;

    my @ret = $self->eval(@args);

    return $self->format(@ret);
}

sub format {
    my ( $self, @stuff ) = @_;

    if ( $self->is_error( $stuff[0] ) ) {
        return $self->format_error(@stuff);
    }
    else {
        return $self->format_result(@stuff);
    }
}

sub format_result {
    my ( $self, @stuff ) = @_;

    return @stuff;
}

sub format_error {
    my ( $self, $error ) = @_;
    return $error->stringify;
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
    my $compiled = eval $self->wrap($line);
    return $self->error_return( "Compile error", $@ ) if $@;
    return $compiled;
}

sub wrap {
    my ( $self, $line ) = @_;
    $line;
}

sub mangle_line {
    my ( $self, $line ) = @_;
    return $line;
}

sub execute {
    my ( $self, $to_exec, @args ) = @_;
    my @ret = eval { $to_exec->(@args) };
    return $self->error_return( "Runtime error", $@ ) if $@;
    return @ret;
}

sub is_error {
    # FIXME
    return 0;
}

sub error_return {
    my ( $self, $type, $error ) = @_;
}

sub print {
    my ( $self, @ret ) = @_;
    my $fh = $self->out_fh;
    no warnings 'uninitialized';
    print $fh "@ret";
    print $fh "\n" if $self->term->ReadLine =~ /Gnu/;
}


sub show_banner {
    print "Welcome to Angelos Console  (c) 2008 Dann.\n";
    print "\n" ;
}

__PACKAGE__->meta->make_immutable;

1;

=head1 AUTHOR

=cut

