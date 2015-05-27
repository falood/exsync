defmodule ExSync.BeamMonitor do
  use ExFSWatch, dirs: ExSync.Config.beam_dirs

  def callback(:stop) do
    IO.puts "STOP"
  end

  def callback(file_path, events) do
    if (Path.extname file_path) in [".beam"] do
      { :created  in events,
        :removed  in events,
        :modified in events,
        file_path |> File.exists?,
      }
   |> case do
        {_, _, true, true} ->   # update
          IO.puts "reload module #{Path.basename file_path, ".beam"}"
          ExSync.Utils.reload file_path
        {true, true, _, false} -> # temp file
          nil
        {_, true, _, false} ->  # remove
          IO.puts "unload module #{Path.basename file_path, ".beam"}"
          ExSync.Utils.unload file_path
        _ ->                    # create
          nil
      end
    end
  end
end
