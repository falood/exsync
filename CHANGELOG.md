# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [Unreleased]

Improvements:

* Make logging configurable and make logging (optionally) not overwrite the IEx prompt [#32](https://github.com/falood/exsync/pull/32)
* Ensure that compilation errors are displayed in the console [#33](https://github.com/falood/exsync/pull/33)
* Add a supervision hierarchy [#35](https://github.com/falood/exsync/pull/35)
* Handle terminals that don't support ANSI colors [#38](https://github.com/falood/exsync/pull/38)
* Improvement to stderr output [#39](https://github.com/falood/exsync/pull/39)

Bug fixes:
* Fix log when there are no configured group leaders [#36](https://github.com/falood/exsync/pull/36)

### Breaking Changes

* Increase minimum supported Elixir version from 1.3 to 1.4

## [0.2.4] - 2019-07-22

* Recursively watch all local path dependencies [#27](https://github.com/falood/exsync/pull/27)
* Optionally call a callback when finished reloading [#21](https://github.com/falood/exsync/pull/21)

## [0.2.3] - 2018-04-23

### Added
* `extra_extensions` option to watch additional extensions
