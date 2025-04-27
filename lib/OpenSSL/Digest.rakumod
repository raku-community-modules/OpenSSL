use OpenSSL::NativeLib;
use NativeCall;

unit module OpenSSL::Digest;

our constant MD5_DIGEST_LENGTH    = 16;
our constant SHA1_DIGEST_LENGTH   = 20;
our constant SHA256_DIGEST_LENGTH = 32;
our constant SHA384_DIGEST_LENGTH = 48;
our constant SHA512_DIGEST_LENGTH = 64;

sub MD5( Blob, size_t, Blob ) is native(&gen-lib)    { ... }
sub SHA1( Blob, size_t, Blob ) is native(&gen-lib)   { ... }
sub SHA256( Blob, size_t, Blob ) is native(&gen-lib) { ... }
sub SHA384( Blob, size_t, Blob ) is native(&gen-lib) { ... }
sub SHA512( Blob, size_t, Blob ) is native(&gen-lib) { ... }

sub md5(Blob $msg) is export {
     my $digest = buf8.allocate(MD5_DIGEST_LENGTH);
     MD5($msg, $msg.bytes, $digest);
     $digest
}

sub sha1(Blob $msg) is export {
     my $digest = buf8.allocate(SHA1_DIGEST_LENGTH);
     SHA1($msg, $msg.bytes, $digest);
     $digest
}

sub sha256(Blob $msg) is export {
     my $digest = buf8.allocate(SHA256_DIGEST_LENGTH);
     SHA256($msg, $msg.bytes, $digest);
     $digest
}

sub sha384(Blob $msg) is export {
     my $digest = buf8.allocate(SHA384_DIGEST_LENGTH);
     SHA384($msg, $msg.bytes, $digest);
     $digest
}

sub sha512(Blob $msg) is export {
     my $digest = buf8.allocate(SHA512_DIGEST_LENGTH);
     SHA512($msg, $msg.bytes, $digest);
     $digest
}

# vim: expandtab shiftwidth=4
