use lib 'blib';
use lib 't/lib';
use lib 'lib';
use Angelos::Test::Benchmark::ModPerl::TestRunPerl;
Angelos::Test::Benchmark::ModPerl::TestRunPerl->new->run(@ARGV);
