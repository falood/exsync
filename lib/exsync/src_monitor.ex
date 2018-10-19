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

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    if Path.extname(path) in ExSync.Config.src_extensions() do
      # This may also vary based on editor - when saving a file in neovim on linux,
      # events received ar3e:
      #   :modified
      #   :modified, :closed
      #   :attribute
      # Rather than coding specific behaviors for each OS, look for the modified event in
      # isolation to trigger things.
      # TODO: untested assumption that this behavior is common across Mac/Linux/Win
      if :modified in events do
        ExSync.Utils.recomplete()
      end
    end

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    Logger.info("ExSync src monitor stopped.")
    {:noreply, state}
  end
end
