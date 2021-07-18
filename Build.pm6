use PathTools;

unit class Build;

method build($cwd --> Bool) {
    my %libraries = ssl => 'ssl', crypto => 'crypto';

    my $prefix;
    if %*ENV<OPENSSL_PREFIX>:exists {
        $prefix = %*ENV<OPENSSL_PREFIX>;
    } elsif !$*DISTRO.is-win {
        my $proc = run "brew", "--prefix", "--installed", "openssl", :out, :!err;
        if ?$proc {
            $prefix = $proc.out.slurp(:close).chomp;
        }
    }
    if $prefix {
        note "Using openssl prefix $prefix";
        %libraries =
            ssl    => $prefix.IO.child('lib').child('ssl').Str,
            crypto => $prefix.IO.child('lib').child('crypto').Str,
        ;
    }

    my $json = Rakudo::Internals::JSON.to-json: %libraries, :pretty, :sorted-keys;
    "resources/libraries.json".IO.spurt: $json;

    # DO NOT COPY THIS SOLUTION
    # Delete precomp files when building in case the openssl libs have since been updated
    # (ideally this type of stale precomp would get picked up by raku)
    # see: https://github.com/sergot/openssl/issues/82#issuecomment-864523511
    try rm($cwd.IO.child('.precomp').absolute, :r, :f, :d);
    try rm($cwd.IO.child('lib/.precomp').absolute, :r, :f, :d);

    return True;
}
