use Test::More;
eval "use Test::NoTabs";
plan skip_all => "Test::NoTabs required for testing POD" if $@;
all_perl_files_ok();
