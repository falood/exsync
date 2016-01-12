defmodule ExSync.SrcMonitor do
  use ExFSWatch, dirs: ExSync.Config.src_dirs

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, _events) do
    if (Path.extname file_path) in ExSync.Config.src_extensions do
      ExSync.Utils.recomplete
    end
  end
end
