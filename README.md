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

3. Add an [MFA](https://codereviewvideos.com/blog/what-is-mfa-in-elixir/) callback so that your code can implement special handling when files are done reloading.

Example config:
```elixir
config :exsync,
  reload_timeout: 75,
  reload_callback: {MyApp.MyModule, :handle_reload, [42]}
```

This will call your `MyApp.MyModule` module after there have been no new reloads detected after 75ms. Specifically it will make a call like `MyApp.MyModule.handle_reload(42)` (any items you put in the list will be added as arguments to [`Task.start/3`](https://hexdocs.pm/elixir/Task.html#start/3))
