package Angelos::Meta::Plugin;
use Mouse;
extends 'Mouse::Meta::Role';

before 'apply' => sub {
    my ( $self, $other ) = @_;
    if ( my $pre = $self->get_method('BEFORE_PLUGIN') ) {
        $pre->body->( $other, $self );
    }
};

after 'apply' => sub {
    my ( $self, $other ) = @_;
    if ( my $pre = $self->get_method('AFTER_PLUGIN') ) {
        $pre->body->( $other, $self );
    }
};

1;
