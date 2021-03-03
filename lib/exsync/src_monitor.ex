defmodule ExSync.SrcMonitor do
  use GenServer

  @throttle_timeout_ms 100

  defmodule State do
    defstruct [:throttle_timer, :file_events, :watcher_pid]
  end

  def start_link(_opts \\ []) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl GenServer
  def init([]) do
    {:ok, watcher_pid} =
      FileSystem.start_link(
        dirs: ExSync.Config.src_dirs(),
        backend: Application.get_env(:file_system, :backend)
      )

    FileSystem.subscribe(watcher_pid)
    ExSync.Logger.debug("ExSync source monitor started.")
    {:ok, %State{watcher_pid: watcher_pid}}
  end

  @impl GenServer
  def handle_info({:file_event, watcher_pid, {path, events}}, %{watcher_pid: watcher_pid} = state) do
    matching_extension? = Path.extname(path) in ExSync.Config.src_extensions()

    # This varies based on editor and OS - when saving a file in neovim on linux,
    # events received are:
    #   :modified
    #   :modified, :closed
    #   :attribute
    # Rather than coding specific behaviors for each OS, look for the modified event in
    # isolation to trigger things.
    matching_event? = :modified in events

    state =
      if matching_extension? && matching_event? do
        maybe_recomplete(state)
      else
        state
      end

    {:noreply, state}
  end

  def handle_info({:file_event, watcher_pid, :stop}, %{watcher_pid: watcher_pid} = state) do
    ExSync.Logger.debug("ExSync src monitor stopped.")
    {:noreply, state}
  end

  def handle_info(:throttle_timer_complete, state) do
    ExSync.Utils.recomplete()
    state = %State{state | throttle_timer: nil}
    {:noreply, state}
  end

  defp maybe_recomplete(%State{throttle_timer: nil} = state) do
    throttle_timer = Process.send_after(self(), :throttle_timer_complete, @throttle_timeout_ms)
    %State{state | throttle_timer: throttle_timer}
  end

  defp maybe_recomplete(%State{} = state), do: state
end
