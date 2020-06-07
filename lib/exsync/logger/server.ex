defmodule ExSync.Logger.Server do
  @moduledoc """
  Receives log messages from ExSync and sends them to the IEx group leader (if it exists)
  """

  use GenServer
  require Logger

  defmodule State do
    defstruct group_leaders: MapSet.new()
  end

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Should be called from IEx
  """
  def register_group_leader do
    if IEx.started?() do
      group_leader = Process.info(self())[:group_leader]
      GenServer.call(__MODULE__, {:register_group_leader, group_leader})
    end
  end

  def debug(message), do: log(:debug, message)
  def info(message), do: log(:info, message)
  def warn(message), do: log(:warn, message)
  def error(message), do: log(:error, message)

  def log(level, message) do
    GenServer.call(__MODULE__, {:log, level, message})
  end

  @impl GenServer
  def init(_opts) do
    {:ok, %State{}}
  end

  @impl GenServer
  def handle_call({:log, level, message}, _from, state) do
    maybe_log(message, level, state.group_leaders)
    {:reply, :ok, state}
  end

  def handle_call({:register_group_leader, pid}, _from, state) do
    {:reply, :ok, %State{state | group_leaders: MapSet.put(state.group_leaders, pid)}}
  end

  defp maybe_log(message, level, group_leaders) do
    if ExSync.Config.logging_enabled() do
      if Enum.empty?(group_leaders) do
        Logger.log(level, message)
      else
        message = color_message(["[exsync] ", message], level)

        MapSet.to_list(group_leaders)
        |> Enum.each(&IO.binwrite(&1, message))
      end
    end
  end

  defp color_message(message, level) do
    color = color(level)
    [IO.ANSI.format_fragment(color, true), message | IO.ANSI.reset()]
  end

  defp color(:debug), do: :cyan
  defp color(:info), do: :normal
  defp color(:warn), do: :yellow
  defp color(:error), do: :red
end
