package Angelos::Controller::Plugin::FillInForm;
use Angelos::Plugin;
use HTML::FillInForm;

sub fillform {
    my $self = shift;
    my $c    = $self->context;
    my $fdat = shift || $c->req->params;
    my $additional_params = shift;

    # For whatever reason your response body is empty. So this fillform() will
    # accomplish nothing. Skip HTML::FillInForm to avoid annoying warnings downstream. 
    return 1 unless my $body = $c->res->body;

    $c->res->body(
        HTML::FillInForm->fill(
            scalarref => \$body,
            fdat      => $fdat,
            %$additional_params,
        )
    );
}

1;

__END__
