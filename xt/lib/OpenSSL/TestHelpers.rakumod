unit module OpenSSL::TestHelpers;

class CurlResult is export {
    has Int $.exitcode;
    has Str $.raw-out;
    has Str $.raw-err;

    has Str $.alpn is rw;
    has Str $.tls-version is rw;
}

#| Returns the path to the program if it is found in C<$PATH>, or Nil otherwise
sub find-program(Str:D $name --> IO::Path) is export {
    %*ENV<PATH>.split(':').map(*.IO.add($name)).first(*.x)
}

#| Runs C<curl> and parses its stderr to collect connection details
sub run-curl(Str:D $host, Int:D :$timeout = 3 --> CurlResult) is export {
    my $curl = find-program('curl');
    return Nil without $curl;
    # C<--write-out '%{json}'> is not enough here because it does not include
    # the negotiated TLS version
    my @args = «"$curl" -v -I --connect-timeout $timeout -- "https://$host/"»;
    my $proc = run @args, :out, :err;
    my $err = $proc.err.slurp(:close);
    my $out = $proc.out.slurp(:close);

    my $r = CurlResult.new(
        :raw-out($out),
        :raw-err($err),
        :exitcode($proc.exitcode)
    );

    given $err {
        / 'ALPN: server accepted ' (\S+) / and $r.alpn = $0.Str;
        / 'SSL connection using ' (\S+) / and $r.tls-version = $0.Str;
    }

    $r
}