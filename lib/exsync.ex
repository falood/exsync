defmodule ExSync do
  def start(_, _) do
    ExSync.SrcMonitor.start
    ExSync.BeamMonitor.start
  end
end
