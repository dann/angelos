package Angelos::Engine::ModPerl;
use Mouse;
use Angelos;
extends 'HTTP::Engine::Interface::ModPerl';

no Mouse;

sub create_engine {
    my ( $class, $r, $context_key ) = @_;
    my $app_class = $class->_load_app_class;
    $class->_setup_home;

    my $app = $app_class->new;
    $app->setup;
    return $app->engine;
}

sub _load_app_class {
    my $app_class = $ENV{ANGELOS_APP_CLASS};
    Mouse::load_class($app_class);
}

sub _setup_home {
    $ENV{ANGELOS_HOME} = $ENV{DOCUMENT_ROOT};
}

__PACKAGE__->meta->make_immutable;

__END__

=head1 NAME

 Angelos::Engine::ModPerl-

=head1 SYNOPSIS

  <VirtualHost 127.0.0.1:8080>
      ServerName hoge.example.com:8080
      DocumentRoot "/var/www/myapp"

      <Location />
          SetHandler modperl
          PerlSetEnv ANGELOS_APP_CLASS MyApp
          PerlResponseHandler Angelos::Server::ModPerl
          PerlSwitches -Mlib=/var/www/myapp/lib
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

1;
