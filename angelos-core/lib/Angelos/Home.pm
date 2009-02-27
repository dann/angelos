package Angelos::Home;
use strict;
use warnings;
use Angelos::Utils;
use Angelos::Exceptions;
use Path::Class qw(dir file);
use File::Spec;
use Cwd ();
use base 'Class::Singleton';

sub _new_instance {
    my $class     = shift;
    my $self      = bless {}, $class;
    my $app_class = shift;
    $self->{home} = $self->detect( $app_class || $self->app_class );
    return $self;
}

sub app_class {
    Angelos::Exception::AbstractMethod->throw( message =>
            'Sub class must implement this method and return application class name'
    );
}

sub detect {
    my ( $self, $app_class ) = @_;
    my $home;
    $home ||= $self->_get_home_from_angelos_env;
    $home ||= $self->_get_home_from_application_env($app_class) if $app_class;
    $home ||= $self->_document_root;
    $home ||= $self->_search_home_from_module_file_path($app_class)
        if $app_class;
    $home ||= $self->_current_dir;
    $home;
}

sub _get_home_from_angelos_env {
    if ( $ENV{ANGELOS_HOME} ) {
        my $home = dir( $ENV{ANGELOS_HOME} )->absolute->cleanup;
        return $home if -d $home;
    }
    return;
}

sub _get_home_from_application_env {
    my ( $self, $app_class ) = @_;
    if ( my $env = Angelos::Utils::env_value( $app_class, 'HOME' ) ) {
        my $home = dir($env)->absolute->cleanup;
        return $home if -d $home;
    }
    return;
}

sub _search_home_from_module_file_path {
    my ( $class, $app_class ) = @_;
    my $home;
    ( my $file = "$app_class.pm" ) =~ s{::}{/}g;
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

                return $home if -d $home;
            }
        }

        {

            # look for an installed Angelos app

            # trim the .pm off the thing ( Foo/Bar.pm -> Foo/Bar/ )
            ( my $path = $inc_entry ) =~ s/\.pm$//;
            my $home = dir($path)->absolute->cleanup;

            # return if if it's a valid directory
            return $home if -d $home;
        }
    }

    # we found nothing
    return;
}

sub _current_dir {
    Cwd::getcwd;
}

sub _document_root {
    if ( $ENV{DOCUMENT_ROOT} && $ENV{MOD_PERL} ) {
        my $home = dir( $ENV{DOCUMENT_ROOT} )->absolute->cleanup;
        return $home if -d $home;
    }
    return;
}

sub path_to {
    my ( $self, @path ) = @_;
    my $path = File::Spec->catfile( $self->{home}, @path );
    if ( -f $path ) {
        return file( $self->{home}, @path );
    }
    else {
        return dir( $self->{home}, @path );
    }
}

1;
