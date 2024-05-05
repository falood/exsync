ExSync
======

An Elixir reloader. When your code changes, ExSync automatically recompiles it.

Supports recompiling `:path` dependencies without additional configuration. Also
supports a `:reload_callback` which is an MFA (Module Function Arguments) that
will be called after each time the code is recompiled.

## System Support

ExSync depends on [FileSystem](https://github.com/falood/file_system) which has
some required dependencies.

## Usage

1. Create a new application:

```bash
mix new my_app
```

2. Add exsync to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:exsync, "~> 0.4", only: :dev},
  ]
end
```

NOTE: if you have an umbrella application then add ExSync to one the apps in the umbrella.

## Config

All configuration for this library is handled via the application environment.

`:addition_dirs` - Additional directories to monitor

For example, to monitor the `priv` directory, add this to your `config.exs`:

```elixir
config :exsync, addition_dirs: ["/priv"]
```

`:extensions` - List of file extensions to watch for changes. Defaults to: `[".erl", ".hrl", ".ex", ".eex"]`

`:extra_extensions` - List of additional extensions to watch for changes (cannot be used with `:extensions`)

For example, to watch `.js` and `.css` files add this to your `config.exs`:

```elixir
config :exsync, extra_extensions: [".js", ".css"]
```

`:logging_enabled` - Set to false to disable logging (default true)

`:reload_callback` - A callback [MFA](https://codereviewvideos.com/blog/what-is-mfa-in-elixir/) that is called when a set of files are done reloading. Can be used to implement your own special handling to react to file reloads.

`:reload_timeout` - Amount of time to wait in milliseconds before triggering the `:reload_callback`. Defaults to 150ms.

For example, to call `MyApp.MyModule.handle_reload()` add this to your `config.exs`:

```elixir
config :exsync,
  reload_timeout: 75,
  reload_callback: {MyApp.MyModule, :handle_reload, []}
```
