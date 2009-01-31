use Test::Dependencies
	exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Angelos::Middleware::MobileAgent/],
	style   => 'light';
ok_dependencies();
