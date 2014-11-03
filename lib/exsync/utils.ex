defmodule ExSync.Utils do
  def recomplete do
    System.cmd "mix", ["compile"], [cd: ExSync.Config.app_source_dir]
  end

  def unload(module) when is_atom(module) do
    module |> :code.purge
    module |> :code.delete
  end

  def unload(beam_path) do
    beam_path |> Path.basename(".beam") |> String.to_atom |> unload
  end


  def reload(beam_path) do      # beam file path
    file = beam_path |> to_char_list
    {:ok, binary, _} = :erl_prim_loader.get_file file
    module = beam_path |> Path.basename(".beam") |> String.to_atom
    :code.load_binary(module, file, binary)
  end
end
