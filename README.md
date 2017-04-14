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
        
4. (Alternative) Always start ExSync when available, add the following to an application's `start/2`:

        defmodule MyApp do
          use Application

          def start(_type, _args) do
            import Supervisor.Spec, warn: false

            case Code.ensure_loaded(ExSync) do
              {:module, ExSync} ->
                ExSync.start()
              {:error, :nofile} ->
                :ok
            end

            # ... rest of your applications start script.
          end
        end

## Usage for umbrella project

1. Create an umbrella project

        mix new my_umbrella_app --umbrella

2. Add exsync to your `mix.exs` dependencies:

        def deps do
          [ {:exsync, "~> 0.1", only: :dev} ]
        end

3. start your umbrella project with `exsync` task

        iex -S mix exsync
