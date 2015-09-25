#! /bin/bash

if [ -f Makefile ]; then
    make distclean
    find . -name \*.gcda -o -name \*.gcno -delete
fi
if [ ! -f configure ]; then
    echo "run from the tinymux/mux dir" >2
    exit 1
fi

covdir=coverage-test-$(date -u +%Y%m%d%H%M%S.%NZ)

mkdir $covdir
if [ $? -ne 0 ]; then
    echo "unable to make covdir $covdir" >2
    exit 1
fi
cd $covdir

export CFLAGS="-g -Wall --coverage"
export CXXFLAGS="$CFLAGS"
export LDFLAGS="--coverage"
export LIBS="-lgcov"
../configure \
    && make -j8 check \
    && lcov --capture --base-directory .. --directory . --output-file coverage.info \
    && genhtml coverage.info --output-directory html

echo "Test results are in $covdir/html/index.html"

#    && gcov -s .. -o . -d -m $(find . -name \*.o) netmux slave stubslave libmux.lo \
