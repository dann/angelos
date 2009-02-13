package Angelos::Script::Command::Po;
use Angelos::Class;
use base qw(Angelos::Script::Command);
use File::Copy ();
use File::Path 'mkpath';
use Locale::Maketext::Extract ();
use File::Find::Rule          ();
use MIME::Types               ();
use Angelos::Home;
use Path::Class;
use Angelos::Exceptions;
use JSON::XS;

our $MIME      = MIME::Types->new();
our $LMExtract = Locale::Maketext::Extract->new;
use constant USE_GETTEXT_STYLE => 1;

with 'Angelos::Class::HomeAware';

=head1 NAME

Angelos::Script::Command::Po - Extract translatable strings from your application

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

sub opt_spec {
    return (
        [ "lang=s",       "language for generatting po" ],
        [ "search_path=s@", "search path" ],
        [ "js",             "js" ],
    );
}

=head2 run

Runs the "update_catalogs" method.

=cut

sub validate_args {
    my ( $self, $opt, $arg ) = @_;
    Angelos::Exception::ParameterMissingError->throw(
        "You need to give your language --lang\n")
        unless $opt->{lang};
}

sub run {
    my ( $self, $opt, $arg ) = @_;

    return $self->generate_javascript_resources($opt) if $opt->{js};
    $self->update_catalogs($opt);
}

sub generate_javascript_resources {
    my ( $self, $opt ) = @_;
    my $js_po_path
        = File::Spec->catfile(
        $self->home->path_to( 'share', 'root', 'static', 'js', 'po' ),
        $opt->{lang} . ".po" );
    $self->_extract_messages_from_js($js_po_path);
    $self->_generate_javascript_dictionary($js_po_path);
}

sub _extract_messages_from_js {
    my $self       = shift;
    my $js_po_path = shift;
    my @js_files   = File::Find::Rule->file->in(
        $self->home->path_to( 'share', 'root', 'static', 'js' ) );

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
        $self->home->path_to( 'share', 'root', 'static', 'js', 'po' ) ];
    $self->update_catalog($js_po_path);

}

sub _generate_javascript_dictionary {
    my ( $self, $translation ) = @_;
    $LMExtract->read_po($translation) if ( -f $translation );
    $LMExtract->set_compiled_entries;
    my %lexicon = $LMExtract->compile(USE_GETTEXT_STYLE);
    my $file
        = $self->home->path_to( 'share', 'root', 'static', 'js', 'dict',
        $self->language . ".json" );
    open my $fh, '>', $file or die "$file: $!";
    print $fh encode_json \%lexicon;
    close $fh;
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
    my ( $self, $opt ) = @_;
    $self->extract_messages($opt);
    my @catalogs = File::Find::Rule->file->in( $self->_po_dir );
    if ( $opt->{lang} ) {
        $self->update_catalog(
            File::Spec->catfile( $self->_po_dir, $opt->{lang} . ".po" ) );
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
    $self->home->path_to( 'share', 'po' );
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
    my ( $self, $opt ) = @_;

    # find all the .pm files in @INC
    my @files
        = File::Find::Rule->file->in(
        $self->home->path_to( 'share', 'root', 'templates' ),
        'lib', 'bin', @{ $opt->{search_path} || [] } );

    foreach my $file (@files) {
        next if $file =~ m{(^|/)[\._]svn/};
        next if $file =~ m{\~$};
        next unless $self->_check_mime_type($file);
        $LMExtract->extract_file($file);
    }

}

1;
