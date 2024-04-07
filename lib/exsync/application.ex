require Logger

defmodule ExSync.Application do
  def start(_, _) do
    case Mix.env() do
      :dev ->
        start_supervisor()

      _ ->
        Logger.error("ExSync NOT started. Only `:dev` environment is supported.")
        {:ok, self()}
    end
  end

  def start() do
    Application.ensure_all_started(:exsync)
  end

  def start_supervisor do
    children =
      [
        maybe_include_src_monitor(),
        ExSync.BeamMonitor
      ]
      |> List.flatten()

    opts = [
      strategy: :one_for_one,
      max_restarts: 2,
      max_seconds: 3,
      name: ExSync.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end

  def maybe_include_src_monitor do
    if ExSync.Config.src_monitor_enabled() do
      [ExSync.SrcMonitor]
    else
      []
    end
  end
end
