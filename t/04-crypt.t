use v6;
use Test;

plan 13;

use OpenSSL::CryptTools;

ok 1, 'can load module';

my $ciphertext = encrypt("asdf".encode, :aes256, :iv(("0" x 16).encode), :key(('x' x 32).encode));
ok $ciphertext, 'can encrypt';
ok $ciphertext ne "asdf".encode, 'encrypt changes data';

my $plaintext = decrypt($ciphertext, :aes256, :iv(("0" x 16).encode), :key(('x' x 32).encode));
ok $plaintext, 'can decrypt';
is $plaintext, "asdf".encode, 'decrypt gets correct data';

# AES Test Vector
my $key = Blob.new( 0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe, 0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81, 0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7, 0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4);
my $test = Blob.new( 0xf6, 0x9f, 0x24, 0x45, 0xdf, 0x4f, 0x9b, 0x17, 0xad, 0x2b, 0x41, 0x7b, 0xe6, 0x6c, 0x37, 0x10);
my $iv = Blob.new(0x39, 0xF2, 0x33, 0x69, 0xA9, 0xD9, 0xBA, 0xCF, 0xA5, 0x30, 0xE2, 0x63, 0x04, 0x23, 0x14, 0x61,);

$ciphertext = encrypt($test, :aes256, :$iv, :$key);
is-deeply $ciphertext[0..^16], (0xb2, 0xeb, 0x05, 0xe2, 0xc3, 0x9b, 0xe9, 0xfc, 0xda, 0x6c, 0x19, 0x07, 0x8c, 0x6a, 0x9d, 0x1b), "got aes256 expected ciphertext";
$plaintext = decrypt($ciphertext, :aes256, :$iv, :$key);
is-deeply $plaintext[0..^16], $test[0..^16], 'aes128 encrypt/decrypt roundtrip';

$iv = Blob.new(234,72,142,51,41,124,195,48,173,92,119,85,68,98,83,7);
$key = Buf.new(153,236,223,14,168,171,126,143,31,34,114,27,15,26,80,70);
$test = Blob.new(80,68,70,45,84,111,111,108,115,47,116,47,100,97,111,45,100,111,99,46,116);

$ciphertext = encrypt($test, :aes128, :$iv, :$key);
is-deeply $ciphertext[0..^16], (97,133,236,148,181,60,72,129,145,40,31,27,41,81,165,18), "got aes128 expected ciphertext";
$plaintext = decrypt($ciphertext, :aes128, :$iv, :$key);
is-deeply $plaintext[0..^16], $test[0..^16], 'aes128 encrypt/decrypt roundtrip';

$ciphertext = encrypt($test, :aes128ctr, :$iv, :$key);
is-deeply $ciphertext[0..^16], (32,47,63,22,170,182,213,205,110,114,47,196,218,57,59,113), "got 'aes128ctr expected ciphertext";
$plaintext = decrypt($ciphertext, :aes128ctr, :$iv, :$key);
is-deeply $plaintext[0..^16], $test[0..^16], 'aes128ctr encrypt/decrypt roundtrip';

$key.reallocate(192 div 8);
$ciphertext = encrypt($test, :aes192, :$iv, :$key);
is-deeply $ciphertext[0..^16], (108, 43, 13, 72, 123, 90, 223, 254, 165, 189, 230, 75, 140, 224, 182, 49), "got aes192 expected ciphertext";
$plaintext = decrypt($ciphertext, :aes192, :$iv, :$key);
is-deeply $plaintext[0..^16], $test[0..^16], 'aes192 encrypt/decrypt roundtrip';
