package Angelos::Engine::ModPerl;
use Mouse;
extends 'HTTP::Engine::Interface::ModPerl';

no Mouse;

sub create_engine {
    my ( $class, $r, $context_key ) = @_;
    $class->_setup_home;

    my $app_class = $class->_load_app_class;
    my $app = $app_class->new( server => 'ModPerl' );
    $app->setup;
    return $app->engine;
}

sub _load_app_class {
    my $app_class = $ENV{ANGELOS_APP_CLASS};
    Mouse::load_class($app_class);
    $app_class;
}

sub _setup_home {
    $ENV{ANGELOS_HOME} = $ENV{DOCUMENT_ROOT};
}

__PACKAGE__->meta->make_immutable;

1;

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
      <Location />
          SetHandler perl-script
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


