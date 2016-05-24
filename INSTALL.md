# Building and Installation

This MUX fork uses a very different configuration, build, and installation system with assumptions more in-line with standard open-source UNIX practice.

* As before, we have a `./configure` script, but now it is hooked in with the rest of the autotools ecosystem.
  * This is mostly a change for people relying on modules or trying to build on windows.
  * MariaDB/MySQL support are auto-enabled if found
  * OpenSSL support is auto-enabled if found
* Building no longer directly installs into `../game/bin`; automake respects configure's `--prefix`.

For example, if you are running a single mux instance in your homedir and want to do an installation there, try something like:

```
cd
git clone https://github.com/lashtear/tinymux.git
cd tinymux/mux
./configure --prefix=$HOME/game
make -j2
make install
```

This will download source and build the game in `~/tinymux/mux` and install to `~/game`.  Note that the tree of files installed will look much different than older MUSH installations.  For example:

```
$ find ~/game
/home/lucca/game
/home/lucca/game/share
/home/lucca/game/share/doc
/home/lucca/game/share/doc/tinymux
/home/lucca/game/share/doc/tinymux/SSL
...
/home/lucca/game/share/doc/tinymux/REALITY.SETUP
/home/lucca/game/var
/home/lucca/game/var/sgp.flat
/home/lucca/game/lib
/home/lucca/game/lib/libmux.la
/home/lucca/game/lib/tinymux
/home/lucca/game/lib/tinymux/sum.so
...
/home/lucca/game/lib/tinymux/sample.la
/home/lucca/game/lib/libmux.so
/home/lucca/game/bin
/home/lucca/game/bin/mux-backup-flat
/home/lucca/game/bin/mux-backup.default
/home/lucca/game/bin/mux-backup
/home/lucca/game/bin/mux-backup-flat.default
/home/lucca/game/bin/mux-start.default
/home/lucca/game/bin/mux-stop
/home/lucca/game/bin/mux-unload-flat
/home/lucca/game/bin/mux-stop.default
/home/lucca/game/bin/mux-unload-flat.default
/home/lucca/game/bin/mux-load-flat
/home/lucca/game/bin/dbconvert
/home/lucca/game/bin/mux-load-flat.default
/home/lucca/game/bin/mux-start
/home/lucca/game/etc
/home/lucca/game/etc/script.conf
/home/lucca/game/etc/compat.conf
/home/lucca/game/etc/alias.conf.default
/home/lucca/game/etc/netmux.conf
/home/lucca/game/etc/compat.conf.default
/home/lucca/game/etc/script.conf.default
/home/lucca/game/etc/art.conf.default
/home/lucca/game/etc/alias.conf
/home/lucca/game/etc/netmux.conf.default
/home/lucca/game/etc/art.conf
/home/lucca/game/etc/text
/home/lucca/game/etc/text/news.txt
/home/lucca/game/etc/text/wizmotd.txt
/home/lucca/game/etc/text/wizmotd.txt.default
/home/lucca/game/etc/text/register.txt.default
/home/lucca/game/etc/text/register.txt
/home/lucca/game/etc/text/quit.txt
/home/lucca/game/etc/text/wizhelp.txt
/home/lucca/game/etc/text/staffhelp.txt
/home/lucca/game/etc/text/motd.txt
/home/lucca/game/etc/text/plushelp.txt.default
/home/lucca/game/etc/text/create_reg.txt
/home/lucca/game/etc/text/badsite.txt.default
/home/lucca/game/etc/text/full.txt
/home/lucca/game/etc/text/down.txt.default
/home/lucca/game/etc/text/newuser.txt.default
/home/lucca/game/etc/text/news.txt.default
/home/lucca/game/etc/text/newuser.txt
/home/lucca/game/etc/text/wizhelp.txt.default
/home/lucca/game/etc/text/motd.txt.default
/home/lucca/game/etc/text/connect.txt.default
/home/lucca/game/etc/text/help.txt
/home/lucca/game/etc/text/wiznews.txt.default
/home/lucca/game/etc/text/guest.txt
/home/lucca/game/etc/text/staffhelp.txt.default
/home/lucca/game/etc/text/down.txt
/home/lucca/game/etc/text/badsite.txt
/home/lucca/game/etc/text/connect.txt
/home/lucca/game/etc/text/create_reg.txt.default
/home/lucca/game/etc/text/full.txt.default
/home/lucca/game/etc/text/guest.txt.default
/home/lucca/game/etc/text/help.txt.default
/home/lucca/game/etc/text/quit.txt.default
/home/lucca/game/etc/text/wiznews.txt
/home/lucca/game/etc/text/plushelp.txt
/home/lucca/game/libexec
/home/lucca/game/libexec/netmux
/home/lucca/game/libexec/stubslave
/home/lucca/game/libexec/slave
```

What are all these files?  Well, the old `game/*`config files are now under `etc/`.  The text files are under `etc/text/`.  The `netmux` binary itself and `stubslave`/`slave` tools it uses are in `libexec/`, because usually you don't invoke them directly.  `bin/` has the tools you do use to start/stop/backup the mux.  The pidfile is in `var/run/` and the game database are in `var/`.  `share/doc/` has the typical bundled documentation.

Files ending with `.default` are the standard versions as generated for this source release.  They will be freely rewritten by `make install` but are also always safe to delete, if that is your preference.  The non-default files are the local game version and will not be edited by future installations.

Assuming that your current working directory is what you set the `--prefix` to:

* Where is `./Startmux`?  How do I start?
  * Use `bin/mux-start`  (and similarly, `bin/mux-stop`)
* How do I load [SGP][SGP]?
  * Use `bin/mux-load-flat var/sgp.flat`
* How do I load (whatever flatfile from where-ever)?
  * Use `bin/mux-load-flat path/to/wherever/whatever/game.flat`
* That didn't work.
  * Did it complain that it was a structure database?  Those don't include everything, so go back and get a real flatfile.
  * Was it in some very non-mux format?  Use the [Omega][Omega] tool.
* How do I backup?
  * see `bin/mux-backup` or `bin/mux-backup-flat` or `bin/mux-unload-flat`
* Why does the game version look strange?
  * Version info is generated using `git describe --long --dirty --tags`.  If you're building from a tagged release, it will be nice and simple.  If you're building from some random point in the git tree, all manner of interesting tagnames might appear, e.g. the `hey-thenomain-*` series.  In all cases, the 7-digit hash gives a precise pointer to exactly what code was used.
* Why `netmux.conf` instead of `mygame.conf`?
  * No reason to rename these files as each game will generally need its own instance tree anyway.

----

* [SGP]: Sandbox Globals Project.  See [info on the tinymux wiki](http://wiki.tinymux.org/index.php/Sandbox_Globals_Project); it's bundled with the distribution and installed as `var/sgp.flat`.
* [Omega]:  Omega is a mush conversion tool included in the distribution, but not built by default.  See the [readme](convert/omega/README).
