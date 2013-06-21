package Ark::Plugin::Encoding::Unicode;
use Ark::Plugin;
use Scalar::Util 'blessed';

use Encode;

sub prepare_encoding {
    my $self = shift;
    my $req  = $self->request;

    my $encode = sub {
        my ($p) = @_;

        my $decoded = Hash::MultiValue->new;

        $p->each(sub {
            $decoded->add( $_[0], decode_utf8($_[1]) );
        });

        $decoded;
    };

    $req->{'request.query'}  = $encode->($req->raw_query_parameters);
    $req->{'request.body'}   = $encode->($req->raw_body_parameters);
    $req->{'request.merged'} = undef;
};

sub finalize_encoding {
    my $self = shift;

    my $res = $self->response;
    $res->body(encode_utf8 $res->body ) if !$res->binary and $res->has_body;
};

1;
