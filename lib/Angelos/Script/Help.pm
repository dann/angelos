package Angelos::Script::Help;
use strict;
use base qw( App::CLI::Command::Help );
use File::Find qw(find);
use Pod::Simple::Text;

sub help_base {
    return "Angelos::Manual";
}

# overide methods because of App::CLI bug
sub run {
    my $self = shift;
    my @topics = @_;

    push @topics, 'commands' unless (@topics);

    foreach my $topic (@topics) {
        if ($topic eq 'commands') {
            $self->brief_usage ($_) for $self->app->files;
        }
        elsif (my $cmd = eval { $self->app->get_cmd ($topic) }) {
            $cmd->usage(1);
        }
        elsif (my $file = $self->_find_topic($topic)) {
            open my $fh, '<:utf8', $file or die $!;
            my $parser = Pod::Simple::Text->new;
            my $buf;
            $parser->output_string(\$buf);
            $parser->parse_file($fh);

            $buf =~ s/^NAME\s+(.*?)::Help::\S+ - (.+)\s+DESCRIPTION/    $1:/;
            print $self->loc_text($buf);
        }
        else {
            die loc("Cannot find help topic '%1'.\n", $topic);
        }
    }
    return;
}

1;

__DATA__

=head1 NAME

Angelos::Script::Help - Show help

=head1 SYNOPSIS

 help COMMAND

=head1 OPTIONS

Optionally help can pipe through a pager, to make it easier to
read the output if it is too long. For using this feature, please
set environment variable PAGER to some pager program.
For example:

    # bash, zsh users
    export PAGER='/usr/bin/less'

    # tcsh users
    setenv PAGER '/usr/bin/less'

=head2 help_base

Angelos's help system also looks in L<Jifty::Manual> and the
subdirectories for any help commands that it can't find help for.

=head1 AUTHOR


=cut

