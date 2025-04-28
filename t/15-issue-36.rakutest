#!/usr/bin/env raku

use v6.c;
use OpenSSL;
use Test;
plan 4;

unless %*ENV<NETWORK_TESTING> {
    diag "NETWORK_TESTING was not set";
    skip-rest("NETWORK_TESTING was not set");
    exit;
}

my $ssl = OpenSSL.new(:client);

my $sock = IO::Socket::INET.new(host => 'api.soundcloud.com', port => 443);

is $ssl.set-socket($sock), 0, 'set-socket success';
$ssl.set-connect-state;
is $ssl.connect, 1, 'connect success';
ok $ssl.write("GET / HTTP/1.1\r\nHost: api.soundcloud.com\r\nConnection:close\r\n\r\n"), 'write success';
ok $ssl.read(1024).chars, "and got some data back";


done-testing;
