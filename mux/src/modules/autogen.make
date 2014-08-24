#! /usr/bin/make -f

.DEFAULT: all
.PHONY: all

all: configure autoconf.h.in

configure autoconf.h.in: configure.ac
	autoreconf -fiv
