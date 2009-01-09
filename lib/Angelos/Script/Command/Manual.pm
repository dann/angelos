package Angelos::Script::Command::Manual;
use base qw(App::Cmd::Command);
use Angelos::Exceptions;
use Pod::Simple::Text;
use Path::Class;

=head1 NAME

Angelos::Script::Command::Manual - 

=head1 DESCRIPTION

    % angelos manual --name Tutorial [--lang ja] 

=head1 METHODS

=head2 options()

=cut

sub opt_spec {
    return ( [ "topic=s", "manual topic" ], [ "lang=s", "language" ], );
}

sub validate_args {
    my ( $self, $opt, $arg ) = @_;

    my $topic = $opt->{topic};

    die "You need to give manual topic name with name option\n"
        unless $topic;
}

sub run {
    my ( $self, $opt, $arg ) = @_;
    my $topic = $opt->{topic} || 'Tutorial';
    my $lang  = $opt->{lang}  || 'en';

    if ( my $file = $self->_find_topic( $topic, $lang ) ) {

        # FIXME later
        open my $fh, '<:utf8', $file or die $!;
        my $parser = Pod::Simple::Text->new;
        my $buf;
        $parser->output_string( \$buf );
        $parser->parse_file($fh);

        $buf =~ s/^NAME\s+(.*?)::Help::\S+ - (.+)\s+DESCRIPTION/    $1:/;
        print $buf;
    }
    else {
        die "Cannot find help topic $topic";
    }
    return;
}

sub help_base {
    return "Angelos::Manual";
}

my ( $inc, @prefix );

sub _find_topic {
    my ( $self, $topic, $lang ) = @_;

    if ( !$inc ) {
        my $pkg = __PACKAGE__;
        $pkg =~ s{::}{/};
        $inc = substr( __FILE__, 0, -length("$pkg.pm") );

        my $base = $self->help_base;
        @prefix = ($base);
        $prefix[0] =~ s{::}{/}g;
        $base      =~ s{::}{/}g;
        push @prefix, $base if $prefix[0] ne $base;
    }

    foreach my $dir ( $inc, @INC ) {
        foreach my $prefix (@prefix) {
            foreach my $basename ( ucfirst( lc($topic) ), uc($topic) ) {
                foreach my $ext ( 'pod', 'pm' ) {
                    my $file = "$dir/$prefix/$lang/$basename.$ext";
                    return $file if -f $file;
                }
            }
        }
    }

    return;
}

1;
