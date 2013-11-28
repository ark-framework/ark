use strict;
use warnings;
use Test::More;
use Ark::Request;

my $req = Ark::Request->new({ QUERY_STRING => "foo=bar" });
is_deeply $req->parameters, { foo => "bar" };
is $req->param('foo'), "bar";
is_deeply [ $req->param ], [ 'foo' ];

$req = Ark::Request->new({ QUERY_STRING => "foo=bar&foo=baz" });
is_deeply $req->parameters, { foo => "baz" };
is $req->param('foo'), "baz";
is_deeply [ $req->param('foo') ] , [ qw(bar baz) ];
is_deeply [ $req->param ], [ 'foo' ];

$req = Ark::Request->new({ QUERY_STRING => "foo=bar&foo=baz&bar=baz" });
is_deeply $req->parameters, { foo => "baz", bar => "baz" };
is_deeply $req->query_parameters, { foo => "baz", bar => "baz" };
is $req->param('foo'), "baz";
is_deeply [ $req->param('foo') ] , [ qw(bar baz) ];
is_deeply [ sort $req->param ], [ 'bar', 'foo' ];


done_testing;
