#! /bin/bash

if [ -f Makefile ]; then
    make distclean
fi
if [ ! -f configure ]; then
    echo "run from the tinymux/mux dir" >2
    exit 1
fi

common="-g -O3 -Wall -pthread"
export CFLAGS="$common -std=c11"
export CXXFLAGS="$common -std=c++11"
export LDFLAGS="-g"
export PPROF_PATH=/usr/bin/google-pprof
./configure --enable-selfcheck && make -j8 && make check HEAPCHECK=normal

