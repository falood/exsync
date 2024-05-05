# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)

## [0.4.1] - 2024-05-05

No longer refuse to start when run when `Mix.env() == :dev`

## [0.4.0] - 2024-04-06

Fix compilation warnings

Allow using file_system 1.0

Update minimum Elixir version to 1.11

Remove the need to use `ExSync.register_group_leader` since the functionality it
provided is no longer needed on newer Elixir/Erlang versions.

This also removes the `ExSync.Logger.Server` module but that is an internal
module that shouldn't have been accessed by user code.

## [0.3.0] - 2023-08-12

Improvements:
* Add support for Elixir 1.15 and OTP 26 [#54](https://github.com/falood/exsync/pull/54)
* Remove excess newlines [#44](https://github.com/falood/exsync/pull/44)
* Make logging configurable and make logging (optionally) not overwrite the IEx prompt [#32](https://github.com/falood/exsync/pull/32)
* Ensure that compilation errors are displayed in the console [#33](https://github.com/falood/exsync/pull/33)
* Add a supervision hierarchy [#35](https://github.com/falood/exsync/pull/35)
* Handle terminals that don't support ANSI colors [#38](https://github.com/falood/exsync/pull/38)
* Improvement to stderr output [#39](https://github.com/falood/exsync/pull/39)

Bug fixes:
* Fix log when there are no configured group leaders [#36](https://github.com/falood/exsync/pull/36)

### Breaking Changes

* Update umbrella instructions [#47](https://github.com/falood/exsync/pull/47)
* Increase minimum supported Elixir version from 1.3 to 1.4

## [0.2.4] - 2019-07-22

* Recursively watch all local path dependencies [#27](https://github.com/falood/exsync/pull/27)
* Optionally call a callback when finished reloading [#21](https://github.com/falood/exsync/pull/21)

## [0.2.3] - 2018-04-23

### Added
* `extra_extensions` option to watch additional extensions
