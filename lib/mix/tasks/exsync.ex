defmodule Mix.Tasks.Exsync do
  use Mix.Task

  def run(_) do
    unless System.get_env("MIX_ENV") do
      Mix.env(:dev)
    end

    Application.ensure_all_started(:exsync)
  end
end
