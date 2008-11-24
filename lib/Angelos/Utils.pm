package Angelos::Utils;
use strict;
use warnings;
use Path::Class;

sub home {
    my $class = shift;
    ( my $file = "$class.pm" ) =~ s{::}{/}g;
    if ( my $inc_entry = $INC{$file} ) {
        {

            # look for an uninstalled Nanto app

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
            ( my $path = $inc_entry ) =~ s/¥.pm$//;
            my $home = dir($path)->absolute->cleanup;

            # return if if it's a valid directory
            return $home if -d $home;
        }
    }

    # we found nothing
    return 0;
}

sub path_to {
    my ($class, @path) = @_;
    my $path = dir( Angelos::Utils->home, @path );
    if ( -d $path ) {
        return $path;
    }
    else {
        return file( Angelos::Utils->home, @path );
    }
}

1;
