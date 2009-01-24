package Angelos::Response;
use Angelos::Class;
use UNIVERSAL::require;
extends 'HTTP::Engine::Response';
with 'Angelos::Class::Configurable';

sub setup {
    my $self = shift;
    for my $mixin ( $self->config->mixins('response') ) {
        my $module = join '::',
            ( 'Angelos', 'Request', 'Mixin', $mixin->{module} );
        $module->require or die "Can't load $module";
        $module->new->SETUP;
    }
}

__END_OF_CLASS__
