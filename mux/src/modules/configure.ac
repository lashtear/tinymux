dnl Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([TinyMUX],[2.12],[lashtear@gmail.com])
AM_INIT_AUTOMAKE([-Wall foreign])
LT_INIT
AC_USE_SYSTEM_EXTENSIONS
AM_PROG_AR
AC_CONFIG_SRCDIR([sample.cpp])
AC_CONFIG_HEADER([autoconf.h])
AC_CONFIG_MACRO_DIR([../m4])

# Checks for programs.
#
AC_PROG_CXX
AC_PROG_CXXCPP
AC_PROG_CC
AC_PROG_CPP
AC_CANONICAL_HOST
AC_USE_SYSTEM_EXTENSIONS

# Checks for libraries.
#
# The following may be removeable:
#   -lcposix: ISC is obsolete as of 2006-07-23.
AC_SEARCH_LIBS([strerror],[cposix])
AC_SEARCH_LIBS([sqrt],[m])
AC_SEARCH_LIBS([mysql_init],[mysqlclient])

AC_MSG_CHECKING(for dlopen)
AC_SEARCH_LIBS([dlopen],[dl])
AC_LINK_IFELSE([AC_LANG_PROGRAM([[
    #include <dlfcn.h>
    ]],[[
    void *mh = dlopen("foo", RTLD_LAZY);
    void *fp = dlsym(mh, "bar");
    void *pe = dlerror();
    int   cc = dlclose(mh);
    ]])],[
    AC_DEFINE([HAVE_DLOPEN], [], [Define if dlopen exists.])
    case "$host" in
    *darwin*) MODULE_EXT="so"
	      MODULE_CPPFLAGS="-bundle -O -g"
	      ;;
    *)        MODULE_EXT="so"
	      MODULE_CPPFLAGS="-shared -fPIC -O -g"
	      ;;
    esac
    MUX_LIBS="-lmux"
    ],[])
AC_SUBST(MODULE_EXT)
AC_SUBST(MODULE_CPPFLAGS)
AC_SUBST(MUX_LIBS)
AC_MSG_CHECKING(for gperftools TCMalloc)
AC_CHECK_LIB([tcmalloc],[malloc])

# Checks for header files.
#
AC_HEADER_DIRENT
AC_HEADER_STDC
AC_HEADER_TIME
AC_CHECK_HEADERS([mysql/mysql.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_TYPE_SIZE_T

# Checks for library functions.
AC_FUNC_FORK

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
