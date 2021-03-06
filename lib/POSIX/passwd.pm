use v6;

use NativeCall;

use POSIX::types_h;
use POSIX::time_h;

unit package POSIX::passwd;

constant group is export = class :: is repr('CStruct') {
has Str         $.name;
has Str         $.password;
has gid_t       $.gid;
has CArray[Str] $.members;
};

constant passwd is export = do given ($*KERNEL) {
  when 'darwin' {
      # OS X defines extra fields in the passwd struct.
      class :: is repr('CStruct') {
        has Str           $.username;
        has Str           $.password;
        has uid_t         $.uid;
        has gid_t         $.gid;
        has darwin_time_t $.changed;
        has Str           $.gecos;
        has Str           $.homedir;
        has Str           $.shell;
        has darwin_time_t $.expiration;
      }
    };

    default {
      # Default passwd struct for Linux and others.
      class :: is repr('CStruct') {
        has Str   $.username;
        has Str   $.password;
        has uid_t $.uid;
        has gid_t $.gid;
        has Str   $.gecos;
        has Str   $.homedir;
        has Str   $.shell;
      }
    };
}

sub getgid( --> gid_t ) is native is export { * };
sub getuid( --> uid_t ) is native is export { * };

sub setgid( gid_t --> int32 ) is native is export { * };
sub setuid( uid_t --> int32 ) is native is export { * };

sub getpwnam( Str --> passwd ) is native is export { * };

sub getgrnam( Str --> group ) is native is export { * };
sub getgrgid( gid_t --> group ) is native is export { * };
