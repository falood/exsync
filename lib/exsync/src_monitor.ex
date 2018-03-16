require Logger

defmodule ExSync.SrcMonitor do
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, watcher_pid} =
      FileSystem.start_link(
        dirs: ExSync.Config.src_dirs(),
        backend: Application.get_env(:file_system, :backend)
      )

    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info(
        {:file_event, watcher_pid, {path, _events}},
        %{watcher_pid: watcher_pid} = state
      ) do
    if Path.extname(path) in ExSync.Config.src_extensions() do
      ExSync.Utils.recomplete()
    end

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    Logger.info("ExSync src monitor stopped.")
    {:noreply, state}
  end
end
