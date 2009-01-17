package Angelos::JobQueue::Gearman::Client;
use Angelos::Class;
use Gearman::Client;
use Storable qw( freeze );

has 'job_servers' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { ['127.0.0.1'] },
);

has 'client' => (
    is      => 'ro',
    default => sub {
        my $client = Gearman::Client->new;
        $client;
    }
);

sub BUILD {
    my $self = shift;
    $self->setup;
}

sub run {
    my $self = shift;

    # do nothing in this class.
}

sub setup {
    my $self = shift;
    $self->_setup_client;
}

sub _setup_client {
    my $self = shift;
    $self->client->set_job_servers( @{ $self->job_servers } );
}

sub add_task {
    my ( $self, $task, $args ) = @_;
    my $gtask = Gearman::Task->new(

        $task->name,
        \freeze( $args->{args} ),
        +{  on_fail => sub {
                $task->on_fail;
            },
            }

    );

    $self->client->dispatch_background($gtask);
}

__END_OF_CLASS__

__END__
