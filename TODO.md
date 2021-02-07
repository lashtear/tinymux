# To-Do

## Buildfixes needed for next release

* Significant codebase neglect has happened!
  * configure isn't correctly working around missing things
  * I halfassed the pcre shift so it depends on it being installed
  * TL;DR on Deb/Ubuntu/Pop/Mint/etc, install:
    * libmariadb-dev-compat
    * libpcre3-dev
    * libssl-dev

## Before next release

* More accessible documentation targetting new MUSH owners
* More accessible documentation targetting existing MUSH owners

## Eventually

* Storage
  * Migrate on-disk DB storage to [LMDB](http://symas.com/mdb/), is it's platform independent for everywhere we might run and is superior in every other conceivable way.
  * More SQL options than just MySQL
	* Postgres would be a good move
	* Verify MariaDB works right
	* SQLite would be very useful for small, independent deployments.
	  * And for SQLite 3 we can use [SQLightning](https://gitorious.org/mdb/sqlightning/source/5a70c78cc0c7b9393ff1373905bf1a852cfab3bc:) and store it in the primary LMDB datastore.
* Memory
  * Rework the memory allocation to drop all of the silly breadcrumbs and use modern leak-tracing tools.
  * Ship with gperftools TCMalloc.
  * Gradually move to VBUFs (variable-size buffers) for most softcode support.
* Network
  * Move to libevent.
  * Use TLS session serialization on `@restart` so that we can carry clients across and not need an auxiliary process like Penn uses.
  * Implement telnet-level MSSP.
  * Add a native websocket server in support of modern javascript clients.
  * LDAP - in support of SSO with common mush-community web services like wikis and forums.
	* Implement authentication of incoming connections via an external LDAP server.
	* Implement servicing of incoming LDAP requests based on internal MUX account data.
* Softcode support
  * Implement various useful odds and ends from Penn to improve cross-mush compatibility and make Alzie (@ccubed) shut up.
	* Especially `regedit()` and friends because @Thenomain and I both need that badly.
  * Implement various useful odds and ends from RHost because there is some really good stuff in there.
  * Native nestable datastructure manipulators -- with I/O for ATCP/JSON/XML/proplist.
  * Text-rendering and layout tools so that CSS-color control and HTML-style tables work on normal text clients sanely.
  * Support key-value store access as an inlinable function similar to existing `sql()` support (see LMDB above)
  * Migrate most text-file things to use key-value store API
	* Still allow reading text-files on disk for legacy weather-code, etc.
	* Support offline/external add/delete/replace of key-value store contents.
  * Builtin diff/patch visualization tools.
  * Builtin softcode format/unformat tools.
  * Offline non-network script-style softcode evaluator for easier regression-testing.
  * Make more code properly re-entrant in support of an eventual migration to a multi-threaded execution architecture with transactional MVCC data model.
  * Various fun feeps
	* Support more calendars, including detailed Julian support.
	* Functions for precise (and *accurate*) calculations of lunar/planetary/celestial positions at arbitrary date/time.
	* Similar functions that can use programmable data in support of fictional solar systems, and at least patched-conics style predictive orbital mechanics calculations.  KerbalMUX, anyone?
* Build/Packaging
  * Will re-Debianize the package using the new automake/libtool work.
  * Migration tools to somewhat-safely move existing mushes into the new style separated game/binary setup.
  * Unified tools for automated backups, a la [mux-git-backup](https://github.com/lashtear/mux-git-backup) and Loki's (@kkragenbrink) [S3 backup tools for mushes](https://github.com/kkragenbrink/hm-s3-backup).
  * Re-organize the build-tree to make Omega a more commonly used and accessible tool because it's amazingly useful.
  * Simplify the color-matching code to give better results on low-color displays.
  * Drop SGP if we can find (write?) a better replacement.
