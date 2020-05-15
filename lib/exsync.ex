require Logger

defmodule ExSync do
  def start(_, _) do
    case Mix.env() do
      :dev ->
        ExSync.Logger.Server.start_link()

        if ExSync.Config.src_monitor_enabled() do
          ExSync.SrcMonitor.start_link()

          if ExSync.Config.logging_enabled() do
            Logger.debug("ExSync source monitor started.")
          end
        end

        ExSync.BeamMonitor.start_link()

        if ExSync.Config.logging_enabled() do
          Logger.debug("ExSync beam monitor started.")
        end

      _ ->
        Logger.error("ExSync NOT started. Only `:dev` environment is supported.")
    end

    {:ok, self()}
  end

  def start() do
    Application.ensure_all_started(:exsync)
  end

  defdelegate register_group_leader, to: ExSync.Logger.Server
end
