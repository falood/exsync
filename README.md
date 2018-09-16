ExSync
======

Yet another Elixir reloader.

## System Support

ExSync deps on [FileSystem](https://github.com/falood/file_system)

## Usage

1. Create a new application:

        mix new my_app

2. Add exsync to your `mix.exs` dependencies:

```elixir
def deps do
  [ {:exsync, "~> 0.2", only: :dev} ]
end
```

3. (If runing Elixir < 1.4) Start your application the usual way, e.g., `iex -S mix`, then:

```elixir
ExSync.start()
```

4. (Alternative) Always start ExSync when available, add the following to an application's `start/2`:

```elixir
defmodule MyApp do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    case Code.ensure_loaded(ExSync) do
      {:module, ExSync = mod} ->
        mod.start()
      {:error, :nofile} ->
        :ok
    end

    # ... rest of your applications start script.
  end
end
```

## Usage for umbrella project

1. Create an umbrella project

        mix new my_umbrella_app --umbrella

2. Add exsync to your `mix.exs` dependencies:

```elixir
def deps do
  [ {:exsync, "~> 0.2", only: :dev} ]
end
```

3. start your umbrella project with `exsync` task

        iex -S mix exsync

## Config

1. add your own dirs to monitor, if you want monitor `priv` dir, use such config:

```elixir
config :exsync, :addition_dirs, ["/priv"]
```

2. add your own extensions

```elixir
config :exsync, :extensions, [".erl", ".hrl", ".ex", ".tpl"]
```
