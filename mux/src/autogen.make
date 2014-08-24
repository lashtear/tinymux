#! /usr/bin/make -f

.DEFAULT: all
.PHONY: all

all: configure autoconf.h.in modules
	$(MAKE) -C modules -f autogen.make all

configure autoconf.h.in: configure.ac
	autoreconf -fiv
