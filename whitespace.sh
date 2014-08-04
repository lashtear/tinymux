#! /bin/sh

echo Converting to tabs
find . \
    -path .git -prune \
    -o\
    -type f \
    -print0 \
    |xargs -0 \
    perl -i -pe 's{^(( {8})+)}{"\t" x (length($1)/8)}e'

#echo Converting to spaces
#find . \
#    -regextype posix-egrep \
#    -path .git -prune\
#    -o\
#    -type f \
#    -regex '^.+\.([cy]pp|ll|[ch]|txt|mux|sh)$' \
#    -print0 \
#    |xargs -0 \
#    perl -i -pe 's{^(\t+)}{" " x (length($1)*8)}e'
