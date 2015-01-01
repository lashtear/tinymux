AUTOMAKE_OPTIONS = foreign subdir-objects
ACLOCAL_AMFLAGS = -I m4
libexec_PROGRAMS = netmux slave
if HAVE_STUB_SLAVE
libexec_PROGRAMS += stubslave
endif

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

slave_SOURCES = slave.cpp slave.h

lib_LTLIBRARIES = libmux.la
libmux_la_SOURCES = libmux.cpp
libmux_la_LDFLAGS = -export-dynamic -avoid-version
libmux_la_LIBADD = $(LIBLTDL)
libmux_la_DEPENDENCIES = $(LTDLDEPS)

lib_LIBRARIES = libversion.a
libversion_a_SOURCES = version.cpp
libversion_a_CPPFLAGS = $(VER_FLG) -DTINYMUX_MODULES

netmux_LDADD = libmux.la libversion.a $(LIBLTDL)
stubslave_SOURCES = stubslave.cpp stubslave.h
stubslave_LDADD = libmux.la $(LIBLTDL)

SUBDIRS = . modules
AM_CPPFLAGS = $(LTDLINCL)
# this really needs to be refactored out
AM_CPPFLAGS += -DTINYMUX_MODULES


# These version-id features require GNUMake, which may be problematic
# in some platforms.
VER_ID_SRC=$(notdir $(firstword $(strip $(wildcard ../../.git) $(wildcard release.txt))))
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
