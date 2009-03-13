#!/usr/bin/perl -w
use FindBin::libs;
use strict;
use warnings;
use TestApp::Schema;
use TestApp::Home;

local *Angelos::Registrar::context = sub { TestApp::Home->instance };
my $schema = TestApp::Schema->master;

#  here's some of the sql that is going to be generated by the schema
#  INSERT INTO artist VALUES (NULL,'Michael Jackson');
#  INSERT INTO artist VALUES (NULL,'Eminem');

my @artists = ( ['Michael Jackson'], ['Eminem'] );
$schema->populate( 'Artist', [ [qw/name/], @artists, ] );

my %albums = (
    'Thriller'                => 'Michael Jackson',
    'Bad'                     => 'Michael Jackson',
    'The Marshall Mathers LP' => 'Eminem',
);

my @cds;
foreach my $lp ( keys %albums ) {
    my $artist
        = $schema->resultset('Artist')->search( { name => $albums{$lp} } );
    push @cds, [ $lp, $artist->first ];
}

$schema->populate( 'Cd', [ [qw/title artist/], @cds, ] );

my %tracks = (
    'Beat It'         => 'Thriller',
    'Billie Jean'     => 'Thriller',
    'Dirty Diana'     => 'Bad',
    'Smooth Criminal' => 'Bad',
    'Leave Me Alone'  => 'Bad',
    'Stan'            => 'The Marshall Mathers LP',
    'The Way I Am'    => 'The Marshall Mathers LP',
);

my @tracks;
foreach my $track ( keys %tracks ) {
    my $cdname
        = $schema->resultset('Cd')->search( { title => $tracks{$track}, } );
    push @tracks, [ $cdname->first, $track ];
}

$schema->populate( 'Track', [ [qw/cd title/], @tracks, ] );

