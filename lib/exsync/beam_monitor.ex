require Logger

defmodule ExSync.BeamMonitor do
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, watcher_pid} = FileSystem.start_link(dirs: ExSync.Config.beam_dirs())
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    if Path.extname(path) in [".beam"] do
      {:created in events, :removed in events, :modified in events, File.exists?(path)}
      |> case do
        # update
        {_, _, true, true} ->
          Logger.info("reload module #{Path.basename(path, ".beam")}")
          ExSync.Utils.reload(path)

        # temp file
        {true, true, _, false} ->
          nil

        # remove
        {_, true, _, false} ->
          Logger.info("unload module #{Path.basename(path, ".beam")}")
          ExSync.Utils.unload(path)

        # create
        _ ->
          nil
      end
    end

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    Logger.info("ExSync beam monitor stopped.")
    {:noreply, state}
  end
end
