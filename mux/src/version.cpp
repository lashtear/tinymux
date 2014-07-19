/*! \file version.cpp
 * \brief Version information.
 *
 * $Id$
 *
 */

#include "copyright.h"
#include "autoconf.h"
#include "config.h"
#include "externs.h"

#include "command.h"

#if !(defined(MUX_BUILD_VER_ID)                                         \
      && defined(MUX_BUILD_BUILDER)                                     \
      && defined(MUX_BUILD_TIME)                                        \
      && defined(MUX_BUILD_CXXVER)                                      \
      && defined(MUX_BUILD_UNAME))
#  error MUX_BUILD_ vars not defined
#endif

#define stringify(x) stringify_(x)
#define stringify_(x) #x

void do_version(dbref executor, dbref caller, dbref enactor, int eval, int key)
{
    UNUSED_PARAMETER(caller);
    UNUSED_PARAMETER(enactor);
    UNUSED_PARAMETER(eval);
    UNUSED_PARAMETER(key);

    notify(executor, mudstate.version);
    notify(executor, tprintf(T("%s\r\n"
                               "Builder: %s\r\n"
                               "Build time: %s\r\n"
                               "Compiler: %s\r\n"
                               "System: %s"),
                             stringify(MUX_BUILD_VER_ID),
                             stringify(MUX_BUILD_BUILDER),
                             stringify(MUX_BUILD_TIME),
                             stringify(MUX_BUILD_CXXVER),
                             stringify(MUX_BUILD_UNAME)));
}

void build_version(void)
{
        mux_sprintf(mudstate.version, sizeof(mudstate.version),
                    T("MUX %s"), stringify(MUX_BUILD_VER_ID));
        mux_sprintf(mudstate.short_ver, sizeof(mudstate.short_ver),
                    T("MUX %s"), stringify(MUX_BUILD_VER_ID));
}

void init_version(void)
{
    STARTLOG(LOG_ALWAYS, "INI", "START");
    log_text(T("Starting: "));
    log_text(mudstate.version);
    ENDLOG;
    STARTLOG(LOG_ALWAYS, "INI", "START");
    log_text(T("Build date: "));
    log_text((UTF8 *)stringify(MUX_BUILD_TIME));
    ENDLOG;
}
