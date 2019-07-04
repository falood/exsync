require Logger

defmodule ExSync do
  def start(_, _) do
    case Mix.env() do
      :dev ->
        if ExSync.Config.src_monitor_enabled() do
          ExSync.SrcMonitor.start_link()
          Logger.debug("ExSync source monitor started.")
        end

        ExSync.BeamMonitor.start_link()
        Logger.debug("ExSync beam monitor started.")

      _ ->
        Logger.error("ExSync NOT started. Only `:dev` environment is supported.")
    end

    {:ok, self()}
  end

  def start() do
    Application.ensure_all_started(:exsync)
  end
end
