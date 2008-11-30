package Angelos::Utils;
use strict;
use warnings;
use Carp;
use Path::Class;
use Class::Inspector;
use Class::MOP;

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
    my ( $class, @path ) = @_;
    my $path = dir( Angelos::Utils->home, @path );
    if ( $path->is_dir ) {
        return $path;
    }
    else {
        return file( Angelos::Utils->home, @path );
    }
}

sub class2appclass {
    my $class = shift || '';
    my $appname = '';
    if ( $class =~ /^(.+?)::([MVC]|Model|View|Controller)::.+$/ ) {
        $appname = $1;
    }
    return $appname;
}

sub class2classprefix {
    my $class = shift || '';
    my $prefix;
    if ( $class =~ /^(.+?::([MVC]|Model|View|Controller))::.+$/ ) {
        $prefix = $1;
    }
    return $prefix;
}

sub class2classsuffix {
    my $class = shift || '';
    my $prefix = class2appclass($class) || '';
    $class =~ s/$prefix\:://;
    return $class;
}

sub ensure_class_loaded {
    my $class = shift;
    my $opts  = shift;

    croak "Malformed class Name $class"
        if $class =~ m/(?:\b\:\b|\:{3,})/;

    croak "Malformed class Name $class"
        if $class =~ m/[^\w:]/;

    croak
        "ensure_class_loaded should be given a classname, not a filename ($class)"
        if $class =~ m/\.pm$/;

    return
        if !$opts->{ignore_loaded}
            && Class::Inspector->loaded($class)
    ;    # if a symbol entry exists we don't load again

 # this hack is so we don't overwrite $@ if the load did not generate an error
    my $error;
    {
        local $@;
        my $file = $class . '.pm';
        $file =~ s{::}{/}g;
        eval { CORE::require($file) };
        $error = $@;
    }

    die $error if $error;
    die "require $class was successful but the package is not defined"
        unless Class::Inspector->loaded($class);

    return 1;
}

1;
