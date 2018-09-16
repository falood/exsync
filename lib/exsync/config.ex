require Logger

defmodule ExSync.Config do
  def reload_timeout do
    Application.get_env(application(), :reload_timeout, 150)
  end

  def reload_callback do
    Application.get_env(application(), :reload_callback)
  end

  def beam_dirs do
    if Mix.Project.umbrella?() do
      for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded() do
        config = [
          umbrella?: true,
          app_path: opts[:build]
        ]

        Mix.Project.in_project(app, opts[:path], config, fn _ -> beam_dirs() end)
      end
    else
      dep_paths =
        Mix.Dep.cached()
        |> Enum.filter(fn dep -> dep.opts[:path] != nil end)
        |> Enum.map(fn %Mix.Dep{app: app, opts: opts} ->
          config = [
            umbrella?: opts[:in_umbrella],
            app_path: opts[:build]
          ]

          Mix.Project.in_project(app, opts[:path], config, fn _ -> beam_dirs() end)
        end)

      [Mix.Project.compile_path() | dep_paths]
    end
    |> List.flatten()
    |> Enum.uniq()
  end

  def src_monitor_enabled do
    case Application.fetch_env(application(), :src_monitor) do
      :error ->
        Logger.debug(
          "Defaulting to enable source monitor, set config :exsync, src_monitor: false to disable"
        )

        true

      {:ok, value} when value in [true, false] ->
        value

      {:ok, invalid} ->
        Logger.error(
          "Value #{inspect(invalid)} not valid for setting :src_monitor, expected true or false.  Enabling source monitor."
        )

        true
    end
  end

  def src_dirs do
    src_default_dirs() ++ src_addition_dirs()
  end

  defp src_default_dirs do
    if Mix.Project.umbrella?() do
      for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded() do
        Mix.Project.in_project(app, opts[:path], fn _ -> src_default_dirs() end)
      end
    else
      dep_paths =
        Mix.Dep.cached()
        |> Enum.filter(fn dep -> dep.opts[:path] != nil end)
        |> Enum.map(fn %Mix.Dep{app: app, opts: opts} ->
          Mix.Project.in_project(app, opts[:path], fn _ -> src_default_dirs() end)
        end)

      self_paths =
        Mix.Project.config()
        |> Keyword.take([:elixirc_paths, :erlc_paths, :erlc_include_path])
        |> Keyword.values()
        |> List.flatten()
        |> Enum.map(&Path.join(app_source_dir(), &1))
        |> Enum.filter(&File.exists?/1)

      [self_paths | dep_paths]
    end
    |> List.flatten()
    |> Enum.uniq()
  end

  defp src_addition_dirs do
    Application.get_env(:exsync, :addition_dirs, [])
    |> Enum.map(&Path.join(app_source_dir(), &1))
    |> Enum.filter(&File.exists?/1)
  end

  def src_extensions do
    Application.get_env(
      :exsync,
      :extensions,
      [".erl", ".hrl", ".ex", ".eex"] ++ Application.get_env(:exsync, :extra_extensions, [])
    )
  end

  def application do
    :exsync
  end

  def app_source_dir do
    Path.dirname(Mix.ProjectStack.peek().file)
  end
end
