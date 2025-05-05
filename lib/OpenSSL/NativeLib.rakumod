unit module OpenSSL::NativeLib;

use Resource::Wrangler;

BEGIN my %libraries = Rakudo::Internals::JSON.from-json: %?RESOURCES<libraries.json>.slurp(:close);

sub ssl-lib is export {
    state $lib = $*DISTRO.is-win
        ?? dll-resource('ssleay32.dll')
        !! $*VM.platform-library-name(%libraries<ssl>.IO).Str;
}

sub gen-lib is export {
    state $lib = $*DISTRO.is-win
        ?? dll-resource('libeay32.dll')
        !! $*VM.platform-library-name(%libraries<ssl>.IO).Str;
}

sub crypto-lib is export {
    state $lib = $*DISTRO.is-win
        ?? dll-resource('libeay32.dll')
        !! $*VM.platform-library-name(%libraries<crypto>.IO).Str;
}

# Windows only
# Problem: The dll files in resources/ don't like to be renamed, but CompUnit::Repository::Installation
# does not provide a mechanism for storing resources without name mangling. Find::Bundled provided
# this before, but it has suffered significant bit rot.
# "Fix": Continue to store the name mangled resource. Check $*TMPDIR/<sha1 of resource path>/$basename
# and use it if it exists, otherwise copy the name mangled file to this location but using the
# original unmangled name.
# XXX: This should be removed when CURI/%?RESOURCES gets a mechanism to bypass name mangling
sub dll-resource($resource-name) {
    load-resource-to-path($resource-name).absolute
}

# vim: expandtab shiftwidth=4
