package Angelos::CLI::Help;
use strict;
use base qw( App::CLI::Command::Help );
use File::Find qw(find);
use Pod::Simple::Text;
use Angelos::Exceptions;

sub help_base {
    Angelos::Exception::AbstractMethod->throw(
        'sub class must implement this method. ex) MyApp::CLI::Help returns "MyApp::Manual"'
    );
}

# overide methods because of App::CLI bug
sub run {
    my $self   = shift;
    my @topics = @_;

    push @topics, 'commands' unless (@topics);

    foreach my $topic (@topics) {
        if ( $topic eq 'commands' ) {
            $self->brief_usage($_) for $self->app->files;
        }
        elsif ( my $cmd = eval { $self->app->get_cmd($topic) } ) {
            $cmd->usage(1);
        }
        elsif ( my $file = $self->_find_topic($topic) ) {
            open my $fh, '<:utf8', $file or die $!;
            my $parser = Pod::Simple::Text->new;
            my $buf;
            $parser->output_string( \$buf );
            $parser->parse_file($fh);

            $buf =~ s/^NAME\s+(.*?)::Help::\S+ - (.+)\s+DESCRIPTION/    $1:/;
            print $self->loc_text($buf);
        }
        else {
            die "Cannot find help topic: $topic";
        }
    }
    return;
}

1;

