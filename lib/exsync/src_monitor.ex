defmodule ExSync.SrcMonitor do
  use ExFSWatch, dirs: ExSync.Config.src_dirs

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, events) do
    if (Path.extname file_path) in [".erl", ".ex"] do
      unless ("Created" in events) and ("Removed" in events) and not ("Updated" in events)do
        IO.puts "recopmile"
        ExSync.Utils.recomplete
      end
    end
  end
end

defmodule ExSync.BeamMonitor do
  use ExFSWatch, dirs: ExSync.Config.beam_dirs

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, events) do
    if (Path.extname file_path) in [".beam"] do
      case {"Created" in events, "Removed" in events, "Updated" in events} do
        {_, _, true} ->         # update
          IO.puts "reload module #{Path.basename file_path}"
          ExSync.Utils.reload file_path
        {true, true, _} ->      # temp file
          nil
        {_, true, _} ->         # remove
          IO.puts "unload module #{Path.basename file_path}"
          ExSync.Utils.unload file_path
        _ ->                    # create
          nil
      end
    end
  end
end
