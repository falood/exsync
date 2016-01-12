defmodule ExSync.Config do
  def beam_dirs do
    if Mix.Project.umbrella? do
      for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded do
        config = [
          umbrella?: true,
          app_path: opts[:build]
        ]
        Mix.Project.in_project(app, opts[:path], config, fn _ -> beam_dirs end)
      end
    else
      [Mix.Project.compile_path]
    end |> List.flatten
  end

  def src_dirs do
    if Mix.Project.umbrella? do
      for %Mix.Dep{app: app, opts: opts} <- Mix.Dep.Umbrella.loaded do
        Mix.Project.in_project(app, opts[:path], fn _ -> src_dirs end)
      end
    else
      Mix.Project.config
   |> Dict.take([:elixirc_paths, :erlc_paths, :erlc_include_path])
   |> Dict.values |> List.flatten
   |> Enum.map(&Path.join app_source_dir, &1)
   |> Enum.filter(&File.exists?/1)
    end |> List.flatten
  end

  def src_extensions do
    Application.get_env(:exsync, :extensions, [".erl", ".hrl", ".ex"])
  end

  def application do
    :exsync
  end

  def app_source_dir do
    Path.dirname Mix.ProjectStack.peek.file
  end
end
