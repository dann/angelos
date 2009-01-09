package Angelos::Model::JobQueue::Gearman;
use Mouse;
extends 'Angelos::JobQueue::Gearman::Client';

no Mouse;

__PACKAGE__->meta->make_immutable;

1;
