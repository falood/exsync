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

1. Create a new application

        mix new my_app

2. Add exsync to your `mix.exs` dependencies:

        def deps do
          [ {:exsync, github: "~> 0.0.3", only: :dev} ]
        end

3. List `:exsync` as your application dependencies:

        def application do
          [ applications: [:exsync] ]
        end
