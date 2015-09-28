#! /bin/bash

set -e

BUILDTOP=$(pwd)
TMPDIR=$BUILDTOP/tmp
mysql --user root < ./mux/test/user-create.sql
mkdir build inst tmp
cd build

common="-g -O3 -Wall -pthread"
export CFLAGS="$common -std=c11"
export CXXFLAGS="$common -std=c++11"
export LDFLAGS="-g"
export PPROF_PATH=/usr/bin/google-pprof

set +e

../mux/configure --enable-selfcheck --prefix=$BUILDTOP/inst
if [ $? -ne 0 ]; then
    echo configure failure
    echo config.log:
    cat config.log
    exit 1
fi
make
if [ $? -ne 0 ]; then
    echo build failure
    exit 1
fi
make check HEAPCHECK=normal
if [ $? -ne 0 ]; then
    echo check failure
    echo test-suite.log:
    cat test-suite.log
    ls -ldFart $TMPDIR/tmp.*/stderr-log
    SEL=$TMPDIR/tmp.*/stderr-log
    for t in $SEL; do
	if [ -f $t ]; then
	    echo $t:
	    cat $t
	fi
    done
    exit 1
fi
make install
