#line 1
use strict;
use warnings;

package Module::Install::PRIVATE::Angelos;
use base qw/Module::Install::Base/;

our $VERSION = '0.01';

package MY;
use Config;
use Apache::TestConfig ();
use File::Spec;

sub test {
    my $self = shift;
    my $env = Apache::TestConfig->passenv_makestr();

    my $tests = "TEST_FILES =\n";

    if (ref $self && exists $self->{'test'}) {
        $tests = 'TEST_FILES = ' . $self->{'test'}->{'TESTS'} . "\n";
    }

    my $preamble = Apache::TestConfig::WIN32 ? "" : <<EOF;
PASSENV = $env
EOF

    my $cover;

    if (eval { require Devel::Cover }) {
        my $atdir = File::Spec->catfile($ENV{HOME}, '.apache-test');

        my $cover_exec = Apache::TestConfig::which("cover");

        my @cover = ("", "testcover :", );
        push @cover, "\t-\@$cover_exec -delete" if $cover_exec;
        push @cover, "\t-HARNESS_PERL_SWITCHES=-MDevel::Cover=+inc,$atdir \\",
            "\tAPACHE_TEST_EXTRA_ARGS=-one-process \$(MAKE) test";
        push @cover, "\t-\@$cover_exec" if $cover_exec;
        $cover = join "\n", @cover, "";
    }
    else {

        $cover = <<'EOF';

testcover :
	@echo "Cannot run testcover action unless Devel::Cover is installed"
	@echo "Don't forget to rebuild your Makefile after installing Devel::Cover"
EOF
    }

    return $preamble . $tests . <<'EOF' . $cover;
TEST_VERBOSE = 0

test_clean :
	$(FULLPERL) -I$(INST_ARCHLIB) -I$(INST_LIB) \
	t/integration/modperl/TEST $(APACHE_TEST_EXTRA_ARGS) -clean

run_tests :
	$(PASSENV) \
	$(FULLPERL) -I$(INST_ARCHLIB) -I$(INST_LIB) \
	t/integration/modperl/TEST $(APACHE_TEST_EXTRA_ARGS) -bugreport -verbose=$(TEST_VERBOSE) $(TEST_FILES)

test :: pure_all test_clean run_tests

test_config :
	$(PASSENV) \
	$(FULLPERL) -I$(INST_ARCHLIB) -I$(INST_LIB) \
	t/integration/modperl/TEST $(APACHE_TEST_EXTRA_ARGS) -conf

cmodules: test_config
	cd c-modules && $(MAKE) all

cmodules_clean: test_config
	cd c-modules && $(MAKE) clean
EOF

}

1;
