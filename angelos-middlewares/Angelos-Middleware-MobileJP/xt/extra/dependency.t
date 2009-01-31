use Test::Dependencies
	exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Angelos::Middleware::MobileJP/],
	style   => 'light';
ok_dependencies();
