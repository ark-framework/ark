package Ark::Request;
use Mouse;

extends 'Plack::Request::WithEncoding';

use Path::AttrRouter::Match;
use Ark::BodyParser;
use Ark::BodyParser::UrlEncoded;
use Ark::BodyParser::MultiPart;
use Ark::BodyParser::JSON;

has match => (
    is      => 'rw',
    isa     => 'Path::AttrRouter::Match',
    handles => [qw/action args captures/],
);

{
    no warnings 'once';
    *arguments = \&args;
}

no Mouse;

sub new_response {
    my $self = shift;
    require Ark::Response;
    Ark::Response->new(@_);
}

sub request_body_parser {
    my $self = shift;
    unless (exists $self->{request_body_parser}) {
        $self->{request_body_parser} = $self->_build_request_body_parser();
    }
    return $self->{request_body_parser};
}

sub _build_request_body_parser {
    my $self = shift;

    my $parser = Ark::BodyParser->new();
    $parser->register(
        'application/x-www-form-urlencoded',
        'Ark::BodyParser::UrlEncoded'
    );
    $parser->register(
        'multipart/form-data',
        'Ark::BodyParser::MultiPart'
    );
    if ( $self->env->{'ark.request.parse_json_body'} ) {
        $parser->register(
            'application/json',
            'Ark::BodyParser::JSON'
        );
    }
    $parser;
}

sub _parse_request_body {
    my $self = shift;
    $self->request_body_parser->parse($self->env);
}

sub uploads {
    my $self = shift;
    unless ($self->env->{'ark.request.upload_parameters'}) {
        $self->_parse_request_body;
    }
    $self->env->{'plack.request.upload'} ||=
        Hash::MultiValue->new(@{$self->env->{'ark.request.upload_parameters'}});
}

sub body_parameters {
    my ($self) = @_;
    $self->env->{'ark.request.body'} ||= $self->_decode_parameters(@{$self->_body_parameters()});
}

sub query_parameters {
    my ($self) = @_;
    $self->env->{'ark.request.query'} ||= $self->_decode_parameters(@{$self->_query_parameters()});
}

sub parameters {
    my $self = shift;
    $self->env->{'ark.request.merged'} ||= do {
        Hash::MultiValue->new(
            $self->query_parameters->flatten,
            $self->body_parameters->flatten,
        );
    };
}

sub _decode_parameters {
    my ($self, @flatten) = @_;
    my @decoded;
    while ( my ($k, $v) = splice @flatten, 0, 2 ) {
        push @decoded, Encode::decode_utf8($k), Encode::decode_utf8($v);
    }
    return Hash::MultiValue->new(@decoded);
}

sub _body_parameters {
    my $self = shift;
    unless ($self->env->{'ark.request.body_parameters'}) {
        $self->_parse_request_body;
    }
    return $self->env->{'ark.request.body_parameters'};
}

sub _query_parameters {
    my $self = shift;
    unless ( $self->env->{'ark.request.query_parameter'} ) {
        $self->env->{'ark.request.query_parameters'} =
            URL::Encode::url_params_flat($self->env->{'QUERY_STRING'});
    }
    return $self->env->{'ark.request.query_parameters'};
}

sub raw_body_parameters {
    my $self = shift;
    unless ($self->env->{'plack.request.body'}) {
        $self->env->{'plack.request.body'} = Hash::MultiValue->new(@{$self->_body_parameters});
    }
    return $self->env->{'plack.request.body'};
}

sub raw_query_parameters {
    my $self = shift;
    unless ($self->env->{'plack.request.query'}) {
        $self->env->{'plack.request.query'} = Hash::MultiValue->new(@{$self->_query_parameters});
    }
    return $self->env->{'plack.request.query'};
}

sub raw_parameters {
    my $self = shift;
    $self->env->{'plack.request.merged'} ||= do {
        Hash::MultiValue->new(
            @{$self->_query_parameters},
            @{$self->_body_parameters}
        );
    };
}

sub raw_param {
    my $self = shift;

    return keys %{ $self->parameters_raw } if @_ == 0;

    my $key = shift;
    return $self->parameters_raw->{$key} unless wantarray;
    return $self->parameters_raw->get_all($key);
}

# for backward compatible
sub wrap {
    my ($class, $req) = @_;

    warn 'Ark::Request#wrap is deprecated. use new() directory instead';
    return $class->new( $req->env );
}

sub uri {
    my $self = shift;

    $self->{uri} ||= $self->SUPER::uri;
    $self->{uri}->clone; # avoid destructive opearation
}

sub base {
    my $self = shift;

    $self->{base} ||= $self->SUPER::base;
    $self->{base}->clone; # avoid destructive operation
}

sub uri_with {
    my ($self, $args) = @_;

    my $uri = $self->uri;

    my %params = $uri->query_form;
    while (my ($k, $v) = each %$args) {
        $params{$k} = $v;
    }
    $uri->query_form(%params);

    return $uri;
}

1;
