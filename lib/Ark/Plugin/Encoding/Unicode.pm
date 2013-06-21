package Ark::Plugin::Encoding::Unicode;
use Ark::Plugin;
use Encode;

sub prepare_encoding {
    my $self = shift;
    my $req  = $self->request;

    $req->decode_paremeters('utf8');
};

sub finalize_encoding {
    my $self = shift;

    my $res = $self->response;
    $res->body(encode_utf8 $res->body ) if !$res->binary and $res->has_body;
};

1;
