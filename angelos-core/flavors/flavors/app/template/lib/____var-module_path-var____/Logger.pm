package [% module %]::Logger;
use base 'Angelos::Logger';
use Angelos::ProjectStructure;
use [% module %]::Home;

sub app_class { '[% module %]'; }

sub logger_config_file_path {
    Angelos::ProjectStructure->new( home => [% module %]::Home->instance )
        ->logger_config_file_path;
}

1;
