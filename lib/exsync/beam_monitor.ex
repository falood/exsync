require Logger

defmodule ExSync.BeamMonitor do
  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init([]) do
    {:ok, watcher_pid} = FileSystem.start_link(dirs: ExSync.Config.beam_dirs)
    FileSystem.subscribe(watcher_pid)
    {:ok, %{watcher_pid: watcher_pid}}
  end

  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid}=state) do
    if Path.extname(path) in [".beam"] do
      { :created  in events,
        :removed  in events,
        :modified in events,
        File.exists?(path)
      } |> case do
        {_, _, true, true} ->   # update
          # At least on linux platform, we're seeing a :modified event followed by a
          # :modified, closed event.  By ensuring the modified event arrives on its own,
          # we should be ablle to ensure we reload only once in a cross-platorm friendly way.
          # Note: TODO I don't have a Mac or Windows env to verify this!
          if [:modified] == events do
            Logger.info "reload module #{Path.basename(path, ".beam")}"
            ExSync.Utils.reload path
          end
        {true, true, _, false} -> # temp file
          nil
        {_, true, _, false} ->  # remove
          Logger.info "unload module #{Path.basename(path, ".beam")}"
          ExSync.Utils.unload path
        _ ->                    # create
          nil
      end
    end
    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid}=state) do
    Logger.info "ExSync beam monitor stopped."
    {:noreply, state}
  end
end
