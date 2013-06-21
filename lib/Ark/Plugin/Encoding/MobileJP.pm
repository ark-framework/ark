package Ark::Plugin::Encoding::MobileJP;
use Ark::Plugin;

use Encode;
use Encode::JP::Mobile ':props';
use Encode::JP::Mobile::Character;
use HTTP::MobileAgent::Plugin::Charset;

has encoding => (
    is      => 'ro',
    isa     => 'Object',
    lazy    => 1,
    default => sub {
        my ($c) = @_;

        unless ($c->can('mobile_agent')) {
            die 'Plugin::Encoding::MobileJP is required Plugin::MobileAgent';
        }

        my $encoding = $c->mobile_agent->encoding;
        ref($encoding) && $encoding->isa('Encode::Encoding')
            ? $encoding
            : Encode::find_encoding($encoding);
    },
);

sub prepare_encoding {
    my ($c) = @_;
    my $req = $c->request;

    my $encode = sub {
        my ($p) = @_;

        my $decoded = Hash::MultiValue->new;
        my $enc = $c->encoding;

        $p->each(sub {
            $decoded->add( $_[0], decode($enc, $_[1]) );
        });
        $decoded;
    };

    $req->{'request.query'}  = $encode->($req->raw_query_parameters);
    $req->{'request.body'}   = $encode->($req->raw_body_parameters);
    $req->{'request.merged'} = undef;
}

my %htmlspecialchars = ( '&' => '&amp;', '<' => '&lt;', '>' => '&gt;', '"' => '&quot;' );
my $htmlspecialchars = join '', keys %htmlspecialchars;

sub finalize_encoding {
    my ($c) = @_;

    if (!$c->res->binary and $c->res->has_body) {
        my $body = $c->res->body;

        $body = encode($c->encoding, $body, sub {
            my $char = shift;
            my $out  = Encode::JP::Mobile::FB_CHARACTER()->($char);

            if ($c->res->content_type =~ /html$|xml$/) {
                $out =~ s/([$htmlspecialchars])/$htmlspecialchars{$1}/ego; # for (>３<)
            }

            $out;
        });

        $c->res->body($body);
    }
}

1;
