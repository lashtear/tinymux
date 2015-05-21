#! /bin/sh
set -e

echo Removing old build infrastructure
rm -rf aclocal.m4 autom4te.cache config libltdl m4

echo LIBTOOLIZE
libtoolize --nonrecursive --copy --quiet

echo ACLOCAL
aclocal -I m4

echo AUTOHEADER
autoheader

echo AUTOMAKE
automake --add-missing --copy 2>&1 \
    | egrep -v ' installing |non-POSIX recursive variable expansion' \
    || true

echo AUTOCONF
autoconf
