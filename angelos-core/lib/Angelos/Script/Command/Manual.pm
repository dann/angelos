package Angelos::Script::Command::Manual;
use strict;
use warnings;
use base qw(Angelos::Script::Command);
use Angelos::Exceptions;
use Pod::Simple::Text;
use Path::Class;

binmode STDIN,  ":utf8";
binmode STDOUT, ":utf8";

=head1 NAME

Angelos::Script::Command::Manual - Show angelos manual 

=head1 DESCRIPTION

    % angelos manual --name Tutorial [--lang ja] 
    % angelos manual --list [--lang ja]

=head1 METHODS

=head2 options()

=cut

sub opt_spec {
    return (
        [ "topic=s", "manual topic" ],
        [ "lang=s",  "language" ],
        [ "list",    "list manual topics" ]
    );
}

sub validate_args {
    my ( $self, $opt, $arg ) = @_;

    return if $opt->{list};

    my $topic = $opt->{topic};
    die "You need to give manual topic name with name option\n"
        unless $topic;
}

sub run {
    my ( $self, $opt, $arg ) = @_;

    my $lang = $opt->{lang} || 'ja';
    if ( $opt->{list} ) {
        $self->list_manual($lang);
    }
    else {
        my $topic = $opt->{topic} || 'Tutorial';
        $self->show_manual( $topic, $lang );
    }
}

sub list_manual {
    my ( $self, $lang ) = @_;
    my $dir = $self->_find_manual_dir($lang);
    foreach my $file ( $dir->children ) {
        my $tutorial_name = $file->basename;
        $tutorial_name =~ s/\.pod$//;
        print $tutorial_name . "\n";
    }
}

my ($inc, @prefix);
sub _find_manual_dir {
    my ( $self, $lang ) = @_;
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
            my $dir = dir( $dir, $prefix, $lang );
            return $dir if -d $dir;
        }
    }
}

sub show_manual {
    my ( $self, $topic, $lang ) = @_;
    if ( my $file = $self->_find_topic( $topic, $lang ) ) {
        my $fh = $file->openr;
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
}

sub help_base {
    return "Angelos::Manual";
}

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
                    my $file = file( $dir, $prefix, $lang, "$basename.$ext" );
                    return $file if -f $file;
                }
            }
        }
    }

    return;
}

1;
