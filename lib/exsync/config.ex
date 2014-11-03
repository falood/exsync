defmodule ExSync.Config do
  def beam_dirs do
    [ Mix.Project.compile_path ]
  end

  def src_dirs do
    Mix.Project.config
 |> Dict.take([:elixirc_paths, :erlc_paths, :erlc_include_path])
 |> Dict.values |> List.flatten
 |> Enum.map(&Path.join app_source_dir, &1)
 |> Enum.filter(&File.exists?/1)
  end

  def application do
    :exsync
  end

  def app_source_dir do
    Path.dirname Mix.ProjectStack.peek.file
  end
end
