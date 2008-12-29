package Angelos::JobQueue::Gearman::Worker;
use Mouse;
use Gearman::Worker;
use Storable qw(thaw);

has 'job_servers' => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { ['127.0.0.1'] },
);

has 'worker' => (
    is      => 'ro',
    default => sub {
        return Gearman::Worker->new;
    }
);

no Mouse;

sub BUILD {
    my $self = shift;
    $self->worker->job_servers( @{ $self->job_servers } );
}

sub register_function {
    my ( $self, $task ) = @_;
    $self->worker->register_function(
        $task->name,
        $task->timeout,
        sub {
            my $job = shift;
            my $arg = thaw( $job->arg );
            $task->execute($arg);
        }
    );
}

sub run {
    my $self = shift;
    $self->worker->work while 1;
}

__PACKAGE__->meta->make_immutable;

1;
