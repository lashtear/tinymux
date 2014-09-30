AUTOMAKE_OPTIONS = foreign subdir-objects
ACLOCAL_AMFLAGS = -I ../m4
pkglib_LTLIBRARIES = funcs.la sample.la sum.la sqlproxy.la sqlslave.la

funcs_la_SOURCES = funcs.cpp
funcs_la_LDFLAGS = -module -avoid-version
funcs_la_LIBADD = ../libmux.la

sample_la_SOURCES = sample.cpp
sample_la_LDFLAGS = -module -avoid-version
sample_la_LIBADD = ../libmux.la

sum_la_SOURCES = sum.cpp
sum_la_LDFLAGS = -module -avoid-version
sum_la_LIBADD = ../libmux.la

sqlproxy_la_SOURCES = sqlproxy.cpp
sqlproxy_la_LDFLAGS = -module -avoid-version
sqlproxy_la_LIBADD = ../libmux.la

sqlslave_la_SOURCES = sqlslave.cpp
sqlslave_la_LDFLAGS = -module -avoid-version
sqlslave_la_LIBADD = ../libmux.la

# this really needs to be refactored out
AM_CPPFLAGS = -DTINYMUX_MODULES
