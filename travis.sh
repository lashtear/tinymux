#! /bin/bash

set -e

BUILDTOP=$(PWD)
mysql --user root < ./mux/test/user-create.sql
mkdir build inst
cd build
../mux/configure --prefix=$BUILDTOP/inst
make -j2 check
make install

