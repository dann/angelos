use Test::Dependencies
	exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic Angelos/],
	style   => 'light';
ok_dependencies();
