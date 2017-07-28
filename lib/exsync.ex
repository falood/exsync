require Logger

defmodule ExSync do
  def start(_, _) do
    case Mix.env do
      :dev ->
        ExSync.SrcMonitor.start_link()
        ExSync.BeamMonitor.start_link()
        Logger.info "ExSync started."
      _ ->
        Logger.error "ExSync NOT started. Only `:dev` environment is supported."
    end
    {:ok, self()}
  end

  def start() do
    Application.ensure_all_started(:exsync)
  end
end
