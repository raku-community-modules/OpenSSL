use OpenSSL;
use Test;

plan 7;

my $ssl = OpenSSL.new;

given $ssl.get-client-ca-list {
    isa-ok $_, OpenSSL::Stack, "get-client-ca-list is-a 'OpenSSL::Stack'";
    ok .num == 0, "get-client-ca-list returned zero entries";
}

throws-like {
    $ssl.use-client-ca-file("non-existent-file.txt");
}, X::OpenSSL::Exception, "Missing cacert.pem file";

# Copied from the Perl 5 "Mozilla-CA-20160104" CPAN distribution
given $ssl.use-client-ca-file($*PROGRAM.parent.child: 'cacert.pem') {
    isa-ok $_, OpenSSL::Stack, "use-client-ca-file is-a 'OpenSSL::Stack'";
    ok .num > 0, "use-client-ca-list returned >0 entries";
}

given $ssl.get-client-ca-list {
    isa-ok $_, OpenSSL::Stack, "get-client-ca-list is-a 'OpenSSL::Stack'";
    ok .num > 0, "get-client-ca-list returned >0 entries";
}
