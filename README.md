ExSync
======

Yet another Elixir reloader.

## System Support

ExSync deps on [ExFSwatch](https://github.com/falood/exfswatch) and ExFSWatch deps on [fs](https://github.com/synrc/fs#backends)

So just like [fs](https://github.com/synrc/fs#backends)

- Mac fsevent
- Linux inotify
- Windows inotify-win (untested)

NOTE: On Linux you need to install inotify-tools.

## Usage

1. Create a new application:

        mix new my_app

2. Add exsync to your `mix.exs` dependencies:

        def deps do
          [ {:exsync, "~> 0.1", only: :dev} ]
        end

3. Start your application the usual way, e.g., `iex -S mix`, then:

        ExSync.start()

## Usage for umbrella project

1. Create an umbrella project

        mix new my_umbrella_app --umbrella

2. Add exsync to your `mix.exs` dependencies:

        def deps do
          [ {:exsync, "~> 0.1", only: :dev} ]
        end

3. start your umbrella project with `exsync` task

        iex -S mix exsync
