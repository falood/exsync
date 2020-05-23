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
    {:ok, GenServer.start_link(__MODULE__, opts, name: __MODULE__)}
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

  def log(message) do
    GenServer.call(__MODULE__, {:log, message})
  end

  @impl GenServer
  def init(_opts) do
    {:ok, %State{}}
  end

  @impl GenServer
  def handle_call({:log, message}, _from, state) do
    maybe_log(message, state.group_leaders)
    {:reply, :ok, state}
  end

  def handle_call({:register_group_leader, pid}, _from, state) do
    {:reply, :ok, %State{state | group_leaders: MapSet.put(state.group_leaders, pid)}}
  end

  defp maybe_log(message, group_leaders) do
    if ExSync.Config.logging_enabled() do
      message = color_message(["[exsync] ", message])

      MapSet.to_list(group_leaders)
      |> Enum.each(&IO.puts(&1, message))
    end
  end

  defp color_message(message) do
    [IO.ANSI.format_fragment(:cyan, true), message | IO.ANSI.reset()]
  end
end
