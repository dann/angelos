use Test::Dependencies
    exclude => [qw/Test::Dependencies Test::Base Test::Perl::Critic MyApp/],
    style   => 'light';
ok_dependencies();
