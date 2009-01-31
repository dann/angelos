package Angelos::Response;
use Angelos::Class;
use UNIVERSAL::require;
with 'Angelos::Class::Configurable';

sub setup {
    my $self = shift;
    for my $mixin ( $self->config->mixins('response') ) {
        my $module = join '::',
            ( 'Angelos', 'Response', 'Mixin', $mixin->{module} );
        $module->require or die "Can't load $module";
        $module->new->SETUP;
    }
}

__END_OF_CLASS__
