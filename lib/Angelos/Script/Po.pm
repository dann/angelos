package Angelos::Script::Po;
use base qw(App::CLI::Command);
use File::Copy ();
use File::Path 'mkpath';
use Locale::Maketext::Extract ();
use File::Find::Rule          ();
use MIME::Types               ();
use Angelos::Home;
use Path::Class;
use Mouse;
use Angelos::Exceptions;

has 'language' => ( is => 'rw', );

no Mouse;

our $MIME      = MIME::Types->new();
our $LMExtract = Locale::Maketext::Extract->new;
use constant USE_GETTEXT_STYLE => 1;

=head1 NAME

Angelos::Script::Po - Extract translatable strings from your application

=head1 DESCRIPTION

Extracts message catalogs for your Angelos app. When run, Angelos will update
all existing message catalogs, as well as create a new one if you specify a --language flag

=head2 options

This script an option, C<--language>, which is optional; it is the
name of a message catalog to create.

It also takes C<--dir> to specify additional directories to extract
from.

If C<--js> is given, other options are ignored and the script will
generate json files for each language under
F<share/web/static/js/dict> from the current po files.  Before doing
so, you might want to run C<jifty po> with C<--dir share/web/static/js>
to include messages from javascript in your po files.

=cut

sub options {
    (   'l|language=s' => 'language',
        'dir=s@'       => 'directories',
        'js'           => 'js',
    );
}

=head2 run

Runs the "update_catalogs" method.

=cut

sub run {
    my $self = shift;
    return $self->_js_gen if $self->{js};

    die 'language option must be set' unless $self->{language};

    $self->update_catalogs;
}

sub _js_gen {
    my $self     = shift;
    my @js_files = File::Find::Rule->file->in(
        Angelos::Home->path_to( 'share', 'root', 'static', 'js' ) );

    for my $file (@js_files) {
        next if $file =~ m/^ext/;
        next if $file =~ m/^yui/;
        next if $file =~ m/^rico/;
        next if $file =~ m/^jquery/;
        next if $file =~ m/^prototype/;
        $LMExtract->extract_file($file);
    }

    $LMExtract->set_compiled_entries;
    $LMExtract->compile(USE_GETTEXT_STYLE);

    mkpath [
        Angelos::Home->path_to( 'share', 'root', 'static', 'js', 'dict' ) ];
    for my $lang ( Angelos::I18N->available_languages ) {
        my $file
            = Angelos::Home->path_to( 'share', 'root', 'static', 'js', 'dict',
            "$lang.json" );
        open my $fh, '>', $file or die "$file: $!";
        no strict 'refs';
        print $fh $self->_po_to_json;
    }
}

sub _po_to_json {

}

=head2 _check_mime_type FILENAME

This routine returns a mimetype for the file C<FILENAME>.

=cut

sub _check_mime_type {
    my $self       = shift;
    my $local_path = shift;
    my $mimeobj    = $MIME->mimeTypeOf($local_path);
    my $mime_type  = ( $mimeobj ? $mimeobj->type : "unknown" );
    return if ( $mime_type =~ /^image/ );
    return 1;
}

=head2 update_catalogs

Extracts localizable messages from all files in your application, finds
all your message catalogs and updates them with new and changed messages.

=cut

sub update_catalogs {
    my $self = shift;
    $self->extract_messages();
    my @catalogs = File::Find::Rule->file->in( $self->_po_dir );
    if ( $self->language ) {
        $self->update_catalog(
            File::Spec->catfile( $self->_po_dir, $self->language . ".po" ) );
    }
    else {
        foreach my $catalog (@catalogs) {
            next if $catalog =~ m{(^|/)\.svn/};
            $self->update_catalog($catalog);
        }
    }
}

sub _po_dir {
    my $self = shift;
    Angelos::Home->path_to( 'share', 'po' );
}

=head2 update_catalog FILENAME

Reads C<FILENAME>, a message catalog and integrates new or changed 
translations.

=cut

sub update_catalog {
    my $self        = shift;
    my $translation = shift;

    $LMExtract->read_po($translation) if ( -f $translation );

    # Reset previously compiled entries before a new compilation
    $LMExtract->set_compiled_entries;
    $LMExtract->compile(USE_GETTEXT_STYLE);

    $LMExtract->write_po($translation);
}

=head2 extract_messages

Find all translatable messages in your application, using 
L<Locale::Maketext::Extract>.

=cut

sub extract_messages {
    my $self = shift;

    # find all the .pm files in @INC
    my @files
        = File::Find::Rule->file->in(
        Angelos::Home->path_to( 'share', 'root', 'templates' ),
        'lib', 'bin', @{ $self->{directories} || [] } );

    foreach my $file (@files) {
        next if $file =~ m{(^|/)[\._]svn/};
        next if $file =~ m{\~$};
        next unless $self->_check_mime_type($file);
        $LMExtract->extract_file($file);
    }

}

1;
