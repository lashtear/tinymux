dnl Process this file with autoconf to produce a configure script.

AC_INIT([TinyMUX],[2.12],[lashtear@gmail.com])
AC_PREREQ([2.69])
AC_CONFIG_AUX_DIR([config])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([-Wall foreign subdir-objects])
AC_USE_SYSTEM_EXTENSIONS
AM_MAINTAINER_MODE([disable])
AM_SILENT_RULES([yes])

AM_PROG_AR

LT_PREREQ([2.4.2])
LT_CONFIG_LTDL_DIR([libltdl])
LT_INIT([dlopen win32-dll disable-static])
LTDL_INIT([convenience nonrecursive])

AC_CONFIG_SRCDIR([game.cpp])
AC_CONFIG_HEADER([autoconf.h])

AC_MSG_CHECKING(whether to enable Reality Levels)
AC_ARG_ENABLE(
  [realitylvls],
  AS_HELP_STRING([--enable-realitylvls],[enable Reality Levels (default is YES)]),
  [
    if test "x$enableval" = "xno"; then
      AC_MSG_RESULT(no)
    else
      AC_MSG_RESULT(yes)
      AC_DEFINE([HAVE_REALITY_LVLS],[1],[Define to enable reality levels])
    fi
  ],
  [
    AC_MSG_RESULT(yes)
    AC_DEFINE([HAVE_REALITY_LVLS],[1])
  ])

AC_MSG_CHECKING(whether to enable WOD Realms)
AC_ARG_ENABLE(
  [wodrealms],
  AS_HELP_STRING([--enable-wodrealms],[enable WOD Realms (default is NO)]),
  [
    if test "x$enableval" = "xno"; then
      AC_MSG_RESULT(no)
    else
      WOD_REALMS="-DWOD_REALMS"
      AC_MSG_RESULT(yes)
      AC_DEFINE([HAVE_WOD_REALMS],[1],[Define to enable WOD realms])
    fi
  ],
  [
    AC_MSG_RESULT(no)
  ])

AC_MSG_CHECKING(whether to enable Memory-Based Database)
AC_ARG_ENABLE(
  [memorybased],
  AS_HELP_STRING([--enable-memorybased],[enable Memory-Based Database (default is NO)]),
  [
    if test "x$enableval" = "xno"; then
      AC_MSG_RESULT(no)
    else
      AC_MSG_RESULT(yes)
      AC_DEFINE([HAVE_MEMORY_BASED],[1],[Define to enable memory-based database])
    fi
  ],
  [
    AC_MSG_RESULT(no)
  ])

AC_MSG_CHECKING(whether to enable Stub Slave)
AC_ARG_ENABLE(
  [stubslave],
  AS_HELP_STRING([--enable-stubslave],[enable Stub Slave (default is YES)]),
  [
    if test "x$enableval" = "xno"; then
      AC_MSG_RESULT(no)
      stubslave=false
    else
      AC_MSG_RESULT(yes)
      AC_DEFINE([HAVE_STUB_SLAVE],[1],[Define to enable the stub slave])
      stubslave=true
    fi
  ],
  [
    AC_MSG_RESULT(yes)
  ])
AM_CONDITIONAL([HAVE_STUB_SLAVE], [test x$stubslave = xtrue])

AC_MSG_CHECKING(whether to perform expensive self-checking)
AC_ARG_ENABLE(
  [selfcheck],
  AS_HELP_STRING([--enable-selfcheck],[enable expensive self-checking (default is NO)]),
  [
    if test "x$enableval" = "xno"; then
      AC_MSG_RESULT(no)
    else
      AC_MSG_RESULT(yes)
      AC_DEFINE([HAVE_SELFCHECK],[1],[enable selfcheck])
    fi
  ],
  [
    AC_MSG_RESULT(no)
  ])

# Checks for programs.
#
AC_PROG_CXX
AC_PROG_CXXCPP
AC_PROG_CC
AC_PROG_CPP
AC_PROG_LN_S
AC_CANONICAL_HOST

AC_CHECK_PROG([HAVE_DOXYGEN],[doxygen],[1],[0])
AC_CHECK_PROG([HAVE_PDFLATEX],[pdflatex],[1],[0])

# Checks for libraries.
#
# The following may be removeable:
#   -lcposix: ISC is obsolete as of 2006-07-23.
AC_MSG_CHECKING(for gperftools TCMalloc)
AC_CHECK_LIB([tcmalloc],[malloc])
AC_SEARCH_LIBS([strerror],[cposix])
AC_SEARCH_LIBS([crypt],[crypt])
AC_SEARCH_LIBS([socket],[socket inet])
AC_SEARCH_LIBS([gethostbyname],[socket nsl bind])
AC_SEARCH_LIBS([inet_addr],[nsl])
AC_SEARCH_LIBS([sqrt],[m])
AC_SEARCH_LIBS([SSL_library_init],[ssl])
AC_SEARCH_LIBS([EVP_DigestInit],[crypto])
AC_SEARCH_LIBS([deflate],[z])
AC_SEARCH_LIBS([mysql_init],[mysqlclient])

# Checks for header files.
#
AC_HEADER_DIRENT
AC_HEADER_STDC
AC_HEADER_TIME
AC_HEADER_SYS_WAIT
AC_CHECK_HEADERS(unistd.h stddef.h memory.h string.h errno.h malloc.h sys/select.h sys/epoll.h sys/event.h)
AC_CHECK_HEADERS(fcntl.h limits.h sys/file.h sys/ioctl.h sys/types.h sys/time.h sys/stat.h sys/param.h sys/fcntl.h)
AC_CHECK_HEADERS(fpu_control.h ieeefp.h fenv.h float.h)
AC_CHECK_HEADERS(netinet/in.h arpa/inet.h netdb.h sys/socket.h)
AC_CHECK_HEADERS([openssl/ssl.h])
AC_CHECK_HEADERS([openssl/evp.h])
AC_CHECK_HEADERS([mysql/mysql.h])
AC_CHECK_HEADERS([zlib.h])
AS_MESSAGE([checking for sys_errlist decl...])
if test $ac_cv_header_errno_h = no; then
    AC_DEFINE([NEED_SYS_ERRLIST_DCL], [], [Define if you need to declare sys_errlist yourself.])
else
    AC_EGREP_HEADER(sys_errlist,errno.h, ,AC_EGREP_HEADER(sys_errlist,stdio.h,,AC_DEFINE(NEED_SYS_ERRLIST_DCL)))
fi

AC_EGREP_HEADER(getpagesize,unistd.h,,AC_DEFINE([NEED_GETPAGESIZE_DCL], [], [Define if you need to declare getpagesize yourself.]))
if test $ac_cv_header_ieeefp_h = yes; then
    AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
    #include <ieeefp.h>
    ]],[[
    int main(int argc, char *argv[])
    {
	fp_prec_t a = fpgetprec();
	fpsetprec(FP_PD);
	return 0;
    }
    ]])],[AC_DEFINE([IEEEFP_H_USEABLE], [], [Define is ieeefp.h is useable.])],[])
fi

if test $ac_cv_header_fenv_h = yes; then
    AC_EGREP_HEADER(fesetprec,fenv.h,AC_DEFINE([HAVE_FESETPREC], [], [Define if fesetprec is available.]))
    AC_EGREP_HEADER(fegetprec,fenv.h,AC_DEFINE([HAVE_FEGETPREC], [], [Define if fegetprec is available.]))
fi

AS_MESSAGE([checking for extended string dcls...])
AC_EGREP_HEADER(rindex,string.h, ,AC_DEFINE([NEED_INDEX_DCL], [], [Define if we need to redefine index/bcopy et. al. to their SYSV counterparts.]))

AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <signal.h>]],[[struct sigcontext scp;]])],[AC_DEFINE([HAVE_STRUCT_SIGCONTEXT], [], [Define if signal handlers have a struct sigcontext as their third arg.])],[])

AS_MESSAGE([checking for malloc dcl...])
querymalloc=no
AC_EGREP_HEADER(realloc,stdlib.h,AC_DEFINE([MALLOC_IN_STDLIB_H], [], [Define if malloc/realloc/free are defined in stdlib.h.]),querymalloc=yes)
if test $ac_cv_header_malloc_h = no && test $querymalloc = yes; then
    AC_DEFINE([NEED_MALLOC_DCL], [], [Define if we need to declare malloc et. al.])
else
    AC_EGREP_HEADER(realloc,malloc.h, ,AC_DEFINE(NEED_MALLOC_DCL))
fi

AS_MESSAGE([checking for vsprintf dcl...])
AC_EGREP_HEADER(vsprintf,stdio.h, ,AC_DEFINE([NEED_VSPRINTF_DCL], [], [Define if you need to declare vsprintf yourself.]))
AS_MESSAGE([checking for sprintf dcl...])
AC_EGREP_HEADER(\<sprintf|\<*sprintf,stdio.h, ,AC_DEFINE([NEED_SPRINTF_DCL], [], [Define if you need to declare sprintf yourself.]))
AS_MESSAGE([checking for extended stdio dcls...])
AC_EGREP_HEADER(fread,stdio.h,AC_DEFINE([EXTENDED_STDIO_DCLS], [], [Define if stdio.h defines lots of extra functions.]))
AS_MESSAGE([checking for extended socket dcls...])
AC_EGREP_HEADER(setsockopt,sys/socket.h,AC_DEFINE([EXTENDED_SOCKET_DCLS], [], [Define if sys/socket.h defines lots of extra functions.]))
AS_MESSAGE([checking for gettimeofday dcl...])
if test $ac_cv_header_time = yes && test $ac_cv_header_sys_time_h = yes ; then
AC_EGREP_HEADER(gettimeofday,[time.h>
#include <sys/time.h], ,AC_DEFINE([NEED_GETTIMEOFDAY_DCL], [], [Define if you need to declare gettimeofday yourself.]))
elif test $ac_cv_header_sys_time_h = yes ; then
AC_EGREP_HEADER(gettimeofday,sys/time.h, ,AC_DEFINE(NEED_GETTIMEOFDAY_DCL))
else
AC_EGREP_HEADER(gettimeofday,time.h, ,AC_DEFINE(NEED_GETTIMEOFDAY_DCL))
fi

# Checks for typedefs, structures, and compiler characteristics.
#
AC_CHECK_HEADER_STDBOOL
AC_C_INLINE
AC_TYPE_OFF_T
AC_TYPE_PID_T
AC_C_RESTRICT
AC_TYPE_SIZE_T
AC_TYPE_SSIZE_T

AC_CHECK_DECLS([sys_siglist],[],[],[#include <signal.h>
/* NetBSD declares sys_siglist in unistd.h.  */
#ifdef HAVE_UNISTD_H
# include <unistd.h>
#endif
])

AC_STRUCT_TM
AC_STRUCT_TIMEZONE
AC_C_CONST

AC_CHECK_SIZEOF([short])
AC_CHECK_SIZEOF([unsigned short])
AC_CHECK_SIZEOF([int])
AC_CHECK_SIZEOF([unsigned int])
AC_CHECK_SIZEOF([long])
AC_CHECK_SIZEOF([unsigned long])
AC_CHECK_SIZEOF([long long])
AC_CHECK_SIZEOF([unsigned long long])
AC_CHECK_SIZEOF([void *])

AS_MESSAGE([checking for socklen_t dcls...])
AC_EGREP_HEADER(socklen_t,sys/socket.h,AC_DEFINE([SOCKLEN_T_DCL], [], [Define if socklen_t is defined.]))
AC_MSG_CHECKING(for sys_signame decl)
AC_EGREP_HEADER(sys_signame,signal.h,AC_DEFINE([HAVE_SYS_SIGNAME], [], [Define if sys_signame[] exists.]) AC_MSG_RESULT(yes),AC_MSG_RESULT(no))
AS_MESSAGE([checking for getrusage dcl...])
AC_EGREP_HEADER(getrusage,sys/resource.h, ,AC_DEFINE([NEED_GETRUSAGE_DCL], [], [Define if you need to declare getrusage yourself.]))
AS_MESSAGE([checking for getrlimit dcl...])
AC_EGREP_HEADER(getrlimit,sys/resource.h, ,AC_DEFINE([NEED_GETRLIMIT_DCL], [], [Define if you need to declare getrlimit yourself.]))
AC_C_BIGENDIAN(AC_DEFINE([WORDS_BIGENDIAN], [], [Define if Big Endian.]),AC_DEFINE([WORDS_LITTLEENDIAN], [], [Define if Little Endian.]),AC_DEFINE([WORDS_UNKNOWN], [], [Define if Unknown Endian.]))

AC_MSG_CHECKING([for in_addr_t])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>
#if STDC_HEADERS
#include <stdlib.h>
#include <stddef.h>
#endif
#if HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif]],[[in_addr_t foo;]])],[AC_DEFINE([HAVE_IN_ADDR_T], [], [Define if your system has the in_addr_t type.])
   AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
AC_MSG_CHECKING([for in_addr])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>
#if STDC_HEADERS
#include <stdlib.h>
#include <stddef.h>
#endif
#if HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif]],[[struct in_addr ia;]])],[AC_DEFINE([HAVE_IN_ADDR], [], [Define if your system has the in_addr type.])
   AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
AC_MSG_CHECKING([for sockaddr_in])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>
#if STDC_HEADERS
#include <stdlib.h>
#include <stddef.h>
#endif
#if HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif]],[[struct sockaddr_in sa;]])],[AC_DEFINE([HAVE_SOCKADDR_IN], [], [Define if your system has the sockaddr_in type.])
   AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
AC_MSG_CHECKING([for in6_addr])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>
#if STDC_HEADERS
#include <stdlib.h>
#include <stddef.h>
#endif
#if HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif]],[[struct in6_addr i6a;]])],[AC_DEFINE([HAVE_IN6_ADDR], [], [Define if your system has the in6_addr type.])
   AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
AC_MSG_CHECKING([for sockaddr_in6])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>
#if STDC_HEADERS
#include <stdlib.h>
#include <stddef.h>
#endif
#if HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif]],[[struct sockaddr_in6 sa6;]])],[AC_DEFINE([HAVE_SOCKADDR_IN6], [], [Define if your system has the sockaddr_in6 type.])
   AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])
AC_MSG_CHECKING([for sockaddr_storage])
AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>
#if STDC_HEADERS
#include <stdlib.h>
#include <stddef.h>
#endif
#if HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif]],[[struct sockaddr_storage ss;]])],[AC_DEFINE([HAVE_SOCKADDR_STORAGE], [], [Define if your system has the sockaddr_storage type.])
   AC_MSG_RESULT(yes)],[AC_MSG_RESULT(no)])

# Checks for library functions.
#
AC_FUNC_VPRINTF
AC_FUNC_ERROR_AT_LINE
AC_FUNC_FORK
AC_FUNC_MALLOC
AC_FUNC_REALLOC

AC_CHECK_FUNCS([alarm crypt dup2 floor getaddrinfo getdtablesize gethostbyaddr gethostbyname getnameinfo getpagesize getrusage gettimeofday inet_ntoa localtime_r log2 memchr memmove memset modf nanosleep pow select setitimer setrlimit socket sqrt strcasecmp strchr strerror strrchr strstr tzset usleep ])
AC_CHECK_FUNCS([pread pwrite])

AS_MESSAGE([checking for IEEE floating-point format...])
AC_RUN_IFELSE([AC_LANG_SOURCE([[
int main(int argc, char *argv[])
{
   const double d_in = -1e-125;
   const unsigned long long i64_out = 0xA5FB13AC9AAF4C0Full;
   union
   {
       unsigned long long i64;
       double             d;
   } u;
   u.d = d_in;
   if (u.i64 == i64_out)
   {
       return 0;
   }
   return 1;
}
]])],[AC_DEFINE([HAVE_IEEE_FP_FORMAT], [], [Define if you have IEEE floating-point formatted numbers.])],[AC_DEFINE([NO_IEEE_FP_FORMAT], [], [Define if you do not have IEEE floating-point formatted numbers.])],[AC_DEFINE(NO_IEEE_FP_FORMAT)])
AS_MESSAGE([checking for IEEE floating-point exception handling...])
AC_RUN_IFELSE([AC_LANG_SOURCE([[
#include <signal.h>
double rZero = 0.0;
int main(int argc, char *argv[])
{
   double d_in;
   const unsigned long long i64_out = 0x7FF0000000000000ull;
   union
   {
       unsigned long long i64;
       double             d;
   } u;
   signal(SIGFPE, SIG_IGN);
   d_in = 1.0/rZero;
   u.d = d_in;
   if (u.i64 == i64_out)
   {
      return 0;
   }
   return 1;
}
]])],[AC_DEFINE([HAVE_IEEE_FP_SNAN], [], [Define if your IEEE floating-point library can generate NaN.])],[AC_DEFINE([NO_IEEE_FP_SNAN], [], [Define if your IEEE floating-point library cannot generate NaN.])],[AC_DEFINE(NO_IEEE_FP_SNAN)])
AS_MESSAGE([checking for how division/moduli of negative quotients are handled...])
AC_RUN_IFELSE([AC_LANG_SOURCE([[
int main(int argc, char *argv[])
{
   int top = -9;
   int bot = 5;
   int quotient = top/bot;
   if (quotient == -1)
   {
       return 0;
   }
   return 1;
}
]])],[AC_DEFINE([SMALLEST_INT_GTE_NEG_QUOTIENT], [], [Define if platform computes integer quotient as the smallest integer greater than or equal to the algebraic quotient.])],[AC_DEFINE([LARGEST_INT_LTE_NEG_QUOTIENT], [], [Define if platform computes integer quotient as the largest integer less than or equal to the algebraic quotient.])],[AC_DEFINE(LARGEST_INT_LTE_NEG_QUOTIENT)])

AS_MESSAGE([checking whether unaligned 'short' access is permitted...])
AC_RUN_IFELSE([AC_LANG_SOURCE([[
int main(int argc, char *argv[])
{
   char foo[sizeof(short)+1];
   short  *ps = (short *)(foo+1);
   *ps = 0;
   return 0;
}
]])],[AC_DEFINE([CAN_UNALIGN_SHORT], [], [Define if unaligned short access is allowed.])],[false],[false])
AS_MESSAGE([checking whether unaligned 'int' access is permitted...])
AC_RUN_IFELSE([AC_LANG_SOURCE([[
int main(int argc, char *argv[])
{
   char foo[sizeof(int)+1];
   int  *pi = (int *)(foo+1);
   *pi = 0;
   return 0;
}
]])],[AC_DEFINE([CAN_UNALIGN_INT], [], [Define if unaligned int access is allowed.])],[false],[false])
AS_MESSAGE([checking whether unaligned 'long' access is permitted...])
AC_RUN_IFELSE([AC_LANG_SOURCE([[
int main(int argc, char *argv[])
{
   char foo[sizeof(long)+1];
   long *pl = (long *)(foo+1);
   *pl = 0;
   return 0;
}
]])],[AC_DEFINE([CAN_UNALIGN_LONG], [], [Define if unaligned long access is allowed.])],[false],[false])
AS_MESSAGE([checking whether unaligned 'long long' access is permitted...])
AC_RUN_IFELSE([AC_LANG_SOURCE([[
int main(int argc, char *argv[])
{
   char foo[sizeof(long long)+1];
   long long *pll = (long long *)(foo+1);
   *pll = 0;
   return 0;
}
]])],[AC_DEFINE([CAN_UNALIGN_LONGLONG], [], [Define if unaligned long long access is allowed.])],[false],[false])

AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[#include <sys/types.h>
#include <sys/socket.h>]],[[struct linger ling; ling.l_onoff = 1;]])],[AC_DEFINE([HAVE_LINGER], [], [Define if struct linger is defined.])],[])

AC_CONFIG_FILES([Makefile])

AC_OUTPUT
