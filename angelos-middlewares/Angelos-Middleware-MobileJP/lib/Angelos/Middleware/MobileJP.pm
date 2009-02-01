package Angelos::Middleware::MobileJP;
use HTTP::Engine::Middleware;
use Encode;
use Encode::JP::Mobile ':props';
use Encode::JP::Mobile::Character;
use HTTP::MobileAgent::Plugin::Charset;
use Data::Visitor::Encode;

has 'encoding' => ( is => 'rw', );

outer_middleware 'HTTP::Engine::Middleware::MobileAgent';

before_handle {
    my ( $c, $self, $req ) = @_;
    my $encoding = $self->_get_mogile_agent($c)->encoding;
    $self->setup_encoding($encoding);
    $self->decode_params($req);
    $req;
};

after_handle {
    my ( $c, $self, $req, $res ) = @_;
    $self->escape_specialchars($res);
    $self->setup_content_type( $self->_get_mogile_agent($c), $res );
    $res;
};

sub _get_mogile_agent {
    my ( $self, $c ) = @_;
    $c->instance_of('Angelos::Middleware::MobileAgent')->mobile_agent;
}

sub setup_encoding {
    my ( $self, $encoding, $req ) = @_;
    $self->encoding(
        do {

            ref($encoding) && $encoding->isa('Encode::Encoding')
                ? $encoding
                : Encode::find_encoding($encoding);
            }
    );
}

sub decode_params {
    my ( $self, $req ) = @_;
    for my $method (qw/params query_params body_params/) {

        for my $value ( values %{ $req->$method } ) {
            next if ref $value && ref $value ne 'ARRAY';

            for my $v ( ref($value) ? @$value : $value ) {
                next if Encode::is_utf8($v);
                $v = $self->encoding->decode($v);
            }
        }
    }

}

my %htmlspecialchars
    = ( '&' => '&amp;', '<' => '&lt;', '>' => '&gt;', '"' => '&quot;' );
my $htmlspecialchars = join '', keys %htmlspecialchars;
our $decoding_content_type = qr{^text|xml$|javascript$};

sub escape_specialchars {
    my ( $self, $res ) = @_;
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
                    $out =~ s/([$htmlspecialchars])/$htmlspecialchars{$1}/ego;
                }

                $out;
            }
        );

        $res->body($body);
    }

}

sub setup_content_type {
    my ( $self, $mobile_agent, $res ) = @_;
    $res->content_type(
        do {
            if ( $mobile_agent->is_docomo ) {
                'application/xhtml+xml';
            }
            else {
                'text/html; charset=' . $self->encoding->mime_name;
            }
            }
    );
    $res;
}

__MIDDLEWARE__

__END__


