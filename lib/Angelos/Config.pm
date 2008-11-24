package Angelos::Config;
use Moose::Role;
use YAML;
with 'MooseX::ConfigFromFile';

sub get_config_from_file {
    my ($class, $file) = @_;
    my $conf = YAML::LoadFile($file);
    $conf;
}

1;
