use strict;
use warnings;
use utf8;
use Ark::Request;
use Encode;
use Test::More;


my $req = Ark::Request->new({});

ok +Encode::is_utf8("ほげ");

done_testing;
