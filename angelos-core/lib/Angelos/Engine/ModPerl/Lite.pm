package Angelos::Engine::ModPerl::Lite;
use Angelos::Class;
extends 'HTTP::Engine::Interface::ModPerl';

no Mouse;

sub create_engine {
    my ( $class, $r, $context_key ) = @_;
    $class->_setup_home;
    my $handler_class = $class->_load_handler_class;
    my $handler = $handler_class->new( server => 'ModPerl' );
    return $handler->engine;
}

sub _load_handler_class {
    my $handler_class = $ENV{ANGELOS_HANDLER_CLASS};
    Any::Moose::load_class($handler_class);
    $handler_class;
}

sub _setup_home {
    $ENV{ANGELOS_HOME} = $ENV{DOCUMENT_ROOT};
}

__END_OF_CLASS__

__END__

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
          PerlSetEnv ANGELOS_HANDLER_CLASS MyApp::Handler::Sample 
          PerlResponseHandler Angelos::Engine::ModPerl::Lite
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


