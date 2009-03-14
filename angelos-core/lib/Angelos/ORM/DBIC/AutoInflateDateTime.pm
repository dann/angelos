package Angelos::ORM::DBIC::AutoInflateDateTime;
use strict;
use warnings;
use UNIVERSAL::require;

use base qw/DBIx::Class/;

__PACKAGE__->mk_group_accessors('simple' => '__datetime_parser');

sub _datetime {
    my $self = shift;
    DateTime->require or die "DateTime is required";
    return 'DateTime';
}

sub _datetime_parser {
    my $self = shift;
    if (my $parser = $self->__datetime_parser) {
      return $parser;
    }
    my $parser = $self->result_source->storage->datetime_parser(@_);
    return $self->__datetime_parser($parser);
}

sub datetime_column {
    my $class = shift;
    my $col   = shift;

    $class->inflate_column($col, {
        inflate => sub {
            my ($value, $obj) = @_;
            return if $value eq '0000-00-00 00:00:00'; # XXX care for mysql return value
            my $dt = $obj->_datetime_parser->parse_datetime($value);
            return $dt ? $class->datetime->from_object(object => $dt) : undef;
        },
        deflate => sub {
            my ($value, $obj) = @_;
            $obj->_datetime_parser->format_datetime($value);
        },
    });
}

sub date_column {
    my $class = shift;
    my $col   = shift;

    $class->inflate_column($col, {
        inflate => sub {
            my ($value, $obj) = @_;
            return if $value eq '0000-00-00'; #XXX care for mysql return value
            my $dt = $obj->_datetime_parser->parse_date($value);
            return $dt ? $class->datetime->from_object(object => $dt) : undef;
        },
        deflate => sub {
            my ($value, $obj) = @_;
            $obj->_datetime_parser->format_date($value);
        },
    });
}

1;
