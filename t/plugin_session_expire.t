use strict;
use warnings;
use Test::More;

my $expires = 60 * 60 * 24;
{
    package TestApp;
    use Ark;

    use_plugins qw/
        Session
        Session::State::Cookie
        Session::Store::Memory
        /;

    conf 'Plugin::Session::State::Cookie' => {
        cookie_expires => $expires, #+1d
    };

    package TestApp::Controller::Root;
    use Ark 'Controller';

    has '+namespace' => default => '';

    sub test_set :Local {
        my ($self, $c) = @_;
        $c->session->set('test', 'dummy');
    }
}


use Ark::Test 'TestApp',
    components       => [qw/Controller::Root/],
    reuse_connection => 1;

{
    my @MON  = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
    my @WDAY = qw( Sun Mon Tue Wed Thu Fri Sat );
    my ($sec, $min, $hour, $mday, $mon, $year, $wday) = gmtime(time + $expires);
    $year += 1900;
    my $expected_expires_str =
        sprintf(
            "%s, %02d-%s-%04d %02d:%02d:%02d GMT",
            $WDAY[$wday], $mday, $MON[$mon], $year, $hour, $min, $sec
        );

    my $res = request(GET => '/test_set');
    my $cookie_header = $res->header('Set-Cookie');
    like( $cookie_header, qr/testapp_session=/, 'session id ok');
    like( $cookie_header, qr/expires=/, 'session expires ok');
    my ($expires_date) = $cookie_header =~ /expires=(.*)$/;
    is ($expires_date, $expected_expires_str, 'session expires date ok');
}

done_testing;
