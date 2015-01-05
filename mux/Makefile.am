AUTOMAKE_OPTIONS = foreign subdir-objects
ACLOCAL_AMFLAGS = -I m4
AM_CPPFLAGS = $(LTDLINCL)

libexec_PROGRAMS = netmux slave
if HAVE_STUB_SLAVE
libexec_PROGRAMS += stubslave
endif

install-exec-hook:
	cd $(DESTDIR)$(bindir) && \
	    $(LN_S) netmux dbconvert

lib_LTLIBRARIES = libmux.la
noinst_LIBRARIES = libversion.a

pkglib_LTLIBRARIES = funcs.la sample.la sum.la sqlproxy.la sqlslave.la
dist_bin_SCRIPTS = scripts/Backup scripts/_backupflat.sh	\
    scripts/db_load scripts/db_unload scripts/Startmux
dist_sysconf_DATA = etc/alias.conf etc/compat.conf etc/netmux.conf	\
    etc/script.conf

textdir = $(sysconfdir)/text
dist_text_DATA = etc/text/badsite.txt etc/text/connect.txt		\
    etc/text/create_reg.txt etc/text/down.txt etc/text/full.txt	\
    etc/text/guest.txt etc/text/help.txt etc/text/motd.txt		\
    etc/text/news.txt etc/text/newuser.txt etc/text/plushelp.txt	\
    etc/text/quit.txt etc/text/register.txt etc/text/staffhelp.txt	\
    etc/text/wizhelp.txt etc/text/wizmotd.txt etc/text/wiznews.txt

dist_localstate_DATA = data/sgp.flat

dist_doc_DATA = doc/ATTACK doc/BACKUPS doc/CHANGES doc/CONFIGURATION doc/CONVERSION doc/CREDITS doc/DISTRIBUTIONS doc/GUESTS doc/INSTALL doc/LIMITS doc/LOCAL doc/MEMORY doc/MODULES doc/NOTES doc/README doc/readme.txt doc/REALITY doc/REALITY.SETUP doc/REALMS doc/SGP doc/SQL doc/SSL

netmux_SOURCES = alarm.cpp alloc.cpp attrcache.cpp boolexp.cpp		\
    bsd.cpp command.cpp comsys.cpp conf.cpp cque.cpp create.cpp	\
    db.cpp db_rw.cpp eval.cpp file_c.cpp flags.cpp funceval.cpp	\
    funceval2.cpp functions.cpp funmath.cpp game.cpp help.cpp		\
    htab.cpp levels.cpp local.cpp log.cpp look.cpp mail.cpp match.cpp	\
    mathutil.cpp mguests.cpp modules.cpp move.cpp muxcli.cpp		\
    netcommon.cpp object.cpp pcre.cpp player.cpp player_c.cpp		\
    plusemail.cpp powers.cpp predicates.cpp quota.cpp rob.cpp set.cpp	\
    sha1.cpp speech.cpp stringutil.cpp strtod.cpp svdhash.cpp		\
    svdrand.cpp timeabsolute.cpp timedelta.cpp timeparser.cpp		\
    timer.cpp timeutil.cpp timezone.cpp unparse.cpp utf8tables.cpp	\
    vattr.cpp walkdb.cpp wild.cpp wiz.cpp alloc.h ansi.h attrcache.h	\
    attrs.h command.h comsys.h config.h copyright.h db.h externs.h	\
    file_c.h flags.h functions.h funmath.h help.h htab.h interface.h	\
    levels.h libmux.h mail.h match.h mathutil.h mguests.h misc.h	\
    modules.h mudconf.h muxcli.h pcre.h powers.h sha1.h slave.h	\
    stringutil.h svdhash.h svdrand.h timeutil.h ucp.h utf8tables.h	\
    vattr.h
netmux_LDADD = libmux.la libversion.a $(LIBLTDL)

slave_SOURCES = slave.cpp slave.h

libmux_la_SOURCES = libmux.cpp
libmux_la_LDFLAGS = -export-dynamic -avoid-version
libmux_la_LIBADD = $(LIBLTDL)
libmux_la_DEPENDENCIES = $(LTDLDEPS)

libversion_a_SOURCES = version.cpp
libversion_a_CPPFLAGS = $(VER_FLG)

stubslave_SOURCES = stubslave.cpp stubslave.h
stubslave_LDADD = libmux.la $(LIBLTDL)

funcs_la_SOURCES = funcs.cpp
funcs_la_LDFLAGS = -module -avoid-version
funcs_la_LIBADD = libmux.la

sample_la_SOURCES = sample.cpp
sample_la_LDFLAGS = -module -avoid-version
sample_la_LIBADD = libmux.la

sum_la_SOURCES = sum.cpp
sum_la_LDFLAGS = -module -avoid-version
sum_la_LIBADD = libmux.la

sqlproxy_la_SOURCES = sqlproxy.cpp
sqlproxy_la_LDFLAGS = -module -avoid-version
sqlproxy_la_LIBADD = libmux.la

sqlslave_la_SOURCES = sqlslave.cpp
sqlslave_la_LDFLAGS = -module -avoid-version
sqlslave_la_LIBADD = libmux.la

# These version-id features require GNUMake, which may be problematic
# in some platforms.
VER_ID_SRC=$(notdir $(firstword $(strip $(wildcard $(srcdir)/../.git) $(wildcard release.txt))))
VER_ID=$(if $(filter .git,$(VER_ID_SRC)),$(GITDESC),\
	  $(if $(filter release.txt,$(VER_ID_SRC)),$(shell cat release.txt),\
	  $(error Unable to determine source version. VER_ID_SRC is $(VER_ID_SRC))))

GITDESC = $(shell git describe --tags --long --dirty)
BUILDER = $(LOGNAME)@$(shell hostname)
BUILDTIME = $(shell date)
CXXVER = $(shell $(CXX) --version | head -n1)
UNAME = $(shell uname -a)
VER_FLG = -DMUX_BUILD_VER_ID="$(VER_ID)" \
	  -DMUX_BUILD_BUILDER="$(BUILDER)" \
	  -DMUX_BUILD_TIME="$(BUILDTIME)" \
	  -DMUX_BUILD_CXXVER="$(CXXVER)" \
	  -DMUX_BUILD_UNAME="$(UNAME)"

## libltdl/ltdl.mk appends to the following variables
## so we set them here before including it:
BUILT_SOURCES   =

#AM_CPPFLAGS        =
AM_LDFLAGS         =

include_HEADERS    =
noinst_LTLIBRARIES =
#lib_LTLIBRARIES   =
EXTRA_LTLIBRARIES  =

EXTRA_DIST   =

CLEANFILES   =
MOSTLYCLEANFILES   =

include libltdl/Makefile.inc
