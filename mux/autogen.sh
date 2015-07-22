#! /bin/sh
set -e

echo Removing old build infrastructure
rm -rf aclocal.m4 autom4te.cache config libltdl m4

echo LIBTOOLIZE
libtoolize --nonrecursive --copy --quiet

echo ACLOCAL
aclocal -I m4

if grep -q AC_CONFIG_HEADERS configure.ac; then
    echo AUTOHEADER
    autoheader
fi

echo AUTOMAKE
automake --add-missing --copy 2>&1 \
    | egrep -v ' installing |non-POSIX recursive variable expansion' \
    || true

echo AUTOCONF
autoconf

perl -i -pe 's/AR_FLAGS=cru/AR_FLAGS=cr/g' configure m4/libtool.m4
