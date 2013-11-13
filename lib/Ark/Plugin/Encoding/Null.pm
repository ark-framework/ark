package Ark::Plugin::Encoding::Null;
use strict;
use warnings;
use Ark::Plugin;

sub prepare_encoding { }; # XXX: Plack::Request::WithEncoding should support no encoding option.
sub finalize_encoding { };

1;

