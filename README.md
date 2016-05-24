# ![Mechanipus Logo](http://mechanipus.com/img/mechanipus-logo-outline64.png) TinyMUX

![Travis build status](https://travis-ci.org/lashtear/tinymux.svg?branch=mechanipus)

This is Chime's (@lashtear) experimental branch of TinyMUX.  It has significant differences from the normal TinyMUX development cycle but should include most of Brazil's (@BrazilOfMUX) work where applicable.

It is not appropriate for all games or environments and is currently in a very rough development stage and not expected to work as a drop-in replacement for existing MUX games.  Primarily, it targets games using the Mechanipus hosting environment, but bug reports from external games are quite welcome.

## Building

Very different configuration and installation layout!  See [Installation](INSTALL.md).

## Code diferences

* Include the previous Mechanipus patches as deployed on [The Reach](http://thereachmux.org/), [Dark Spires](http://darkspires.org/), et al.  See the `mechanipus-rebased-vs-git_dev` branch for more portable versions of these.
  * `BLIND` rooms for truly quiet quietrooms.
  * 64000 byte LBUFs, including tweaks to the [Boyer-Moore-Horspool](http://en.wikipedia.org/wiki/Boyer%E2%80%93Moore%E2%80%93Horspool_algorithm) code to make this work.
  * Command lookups on master room objects consider object-parents.
  * Bare `think` will not adjust idle time; many clients use this as a client-to-server activity tool, rather than telnet no-ops.  Unfortunate, but harmless.
* Version generated from `git describe`; see [Installation](INSTALL.md) for more info.
* Contains @raelik's ATCP code.

## Plans / ToDo items

See [To-do list](TODO.md)
