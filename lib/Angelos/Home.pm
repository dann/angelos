package Angelos::Home;
use Angelos::Utils;
use Path::Class qw(dir file);

our $HOME;

sub home {
    my ( $class, $app ) = @_;
    if ($HOME) {
        return $HOME;
    }

    if ( $ENV{ANGELOS_HOME} ) {
        $HOME ||= dir( $ENV{ANGELOS_HOME} )->absolute->cleanup;
        return $HOME if -d $HOME;
    }
    $HOME ||= $class->_detect_home($app);
    $HOME;
}

# FIXME
sub _detect_home {
    my ( $class, $clazz ) = @_;
    ( my $file = "$clazz.pm" ) =~ s{::}{/}g;
    if ( my $inc_entry = $INC{$file} ) {
        {

            # find the @INC entry in which $file was found
            ( my $path = $inc_entry ) =~ s/$file$//;
            my $home = dir($path)->absolute->cleanup;

            # pop off /lib and /blib if they're there
            $home = $home->parent while $home =~ /b?lib$/;

            # only return the dir if it has a Makefile.PL or Build.PL
            if ( -f $home->file("Makefile.PL") or -f $home->file("Build.PL") )
            {

                # clean up relative path:
                # MyApp/script/.. -> MyApp

                my ($lastdir) = $home->dir_list( -1, 1 );
                if ( $lastdir eq '..' ) {
                    $home = dir($home)->parent->parent;
                }

                return $home;
            }
        }

        {

            # look for an installed Catalyst app

            # trim the .pm off the thing ( Foo/Bar.pm -> Foo/Bar/ )
            ( my $path = $inc_entry ) =~ s/\.pm$//;
            my $home = dir($path)->absolute->cleanup;

            # return if if it's a valid directory
            return $home if -d $home;
        }
    }

    # we found nothing
    return 0;
}

sub path_to {
    my ( $class, @path ) = @_;
    my $path = dir( Angelos::Home->home, @path );
    if ( $path->is_dir ) {
        return $path;
    }
    else {
        return file( Angelos::Home->home, @path );
    }
}

1;

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
