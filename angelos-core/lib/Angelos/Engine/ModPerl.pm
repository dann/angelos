package Angelos::Engine::ModPerl;
use Angelos::Class;
extends 'HTTP::Engine::Interface::ModPerl';

sub create_engine {
    my ( $class, $r, $context_key ) = @_;
    my $app_class = $class->_load_app_class;
    my $app = $app_class->new( server => 'ModPerl' );
    $app->setup;
    return $app->engine->engine;
}

sub _load_app_class {
    my $app_class = $ENV{ANGELOS_APP_CLASS};
    Mouse::load_class($app_class);
    $app_class;
}

__END_OF_CLASS__

__END__

=head1 NAME

 Angelos::Engine::ModPerl-

=head1 SYNOPSIS

  <VirtualHost *:80>
      ServerName angelos.org
      DocumentRoot /var/www/myapp

      <Perl>
          use lib qw(/var/www/myapp/lib);
      </Perl>
      <Location /modperl/angelos>
          SetHandler modperl
          PerlOptions +SetupEnv
          PerlSetEnv ANGELOS_APP_CLASS MyApp 
          PerlResponseHandler Angelos::Engine::ModPerl
      </Location>
  </VirtualHost>

=head1 DESCRIPTION


=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


