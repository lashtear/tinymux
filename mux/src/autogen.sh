#! /bin/sh

# do not use -f (--force); the ltdl install has customizations to use
# local m4 and config aux dirs.
autoconf -iv

# similarly, clean up the blindly copied subdirs
rm -rf libltdl/config libltdl/m4
