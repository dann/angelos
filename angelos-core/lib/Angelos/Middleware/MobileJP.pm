package Angelos::Middleware::MobileJP;
use Angelos::Class;

use Encode;
use Encode::JP::Mobile ':props';
use Encode::JP::Mobile::Character;
use HTTP::MobileAgent::Plugin::Charset;
use Data::Visitor::Encode;

has 'encoding' => (
    is => 'rw',
);

sub wrap {
    my ( $self, $next ) = @_;
    sub {
        my $req = shift;
        $self->setup_encoding($req);
        $self->decode_params($req);
        my $res = $next->($req);
        my $encoding = $req->mobile_agent->encoding;
        $self->escape_specialchars($res, $encoding);
        $res;
    };
}

sub setup_encoding {
    my ($self, $req) = @_;

    $self->encoding(do {
        my $encoding = $req->mobile_agent->encoding;
        ref($encoding) && $encoding->isa('Encode::Encoding')
            ? $encoding
            : Encode::find_encoding($encoding);
    });

}

sub decode_params {
    my ( $self, $req ) = @_;
    my $encoding = $req->mobile_agent->encoding;
    for my $method (qw/params query_params body_params/) {
        $req->$method(
            Data::Visitor::Encode->decode( $encoding, $req->$method ) );
    }
}

my %htmlspecialchars
    = ( '&' => '&amp;', '<' => '&lt;', '>' => '&gt;', '"' => '&quot;' );
my $htmlspecialchars = join '', keys %htmlspecialchars;
our $decoding_content_type = qr{^text|xml$|javascript$};

sub escape_specialchars {
    my ( $self, $res, $encoding ) = @_;
    my $body = $res->body;
    if (    $body
        and not ref($body)
        and $res->content_type =~ $decoding_content_type )
    {
        $body = $self->encoding->encode(
            $body,
            sub {
                my $char = shift;
                my $out  = Encode::JP::Mobile::FB_CHARACTER()->($char);

                if ( $res->content_type =~ /html$|xml$/ ) {
                    $out =~ s/([$htmlspecialchars])/$htmlspecialchars{$1}/ego
                        ;    # for (>３<)
                }

                $out;
            }
        );

        $res->body($body);
    }

}

__END_OF_CLASS__

__END__
