use Test;
use OpenSSL::Version;

plan 9;

isa-ok OpenSSL::Version::version_num(), Int, "version_num() is-a 'Int'";
isa-ok OpenSSL::Version::version(), Str, "version() is-a 'Str'";
isa-ok OpenSSL::Version::version(OpenSSL::Version::VERSION), Str,
    "version(VERSION) is-a 'Str'";
is OpenSSL::Version::version(),
   OpenSSL::Version::version(OpenSSL::Version::VERSION),
   'version() eq version(VERSION)';
isa-ok OpenSSL::Version::version(OpenSSL::Version::CFLAGS), Str,
   "version(CFLAGS) is-a 'Str'";
isa-ok OpenSSL::Version::version(OpenSSL::Version::BUILT_ON), Str,
   "version(BUILT_ON) is-a 'Str'";
isa-ok OpenSSL::Version::version(OpenSSL::Version::PLATFORM), Str,
    "version(PLATFORM) is-a 'Str'";
isa-ok OpenSSL::Version::version(OpenSSL::Version::DIR), Str,
    "version(DIR) is-a 'Str'";
isa-ok OpenSSL::Version::version(OpenSSL::Version::ENGINES_DIR), Str,
    "version(ENGINES_DIR) is-a 'Str'";
