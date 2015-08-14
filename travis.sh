#! /bin/bash

set -e

BUILDTOP=$(pwd)
mysql --user root < ./mux/test/user-create.sql
mkdir build inst
cd build
../mux/configure --prefix=$BUILDTOP/inst

set +e

make -j2 check
e=$?
echo Check exit was $e
cat test-suite.log
if [ $e -eq 0 ]; then
    make install
fi

