#! /bin/sh

rm -rf libltdl && libtoolize --nonrecursive --copy --quiet
aclocal -I m4
autoheader
automake
autoconf
