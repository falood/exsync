require Logger

defmodule ExSync.Utils do
  def recomplete do
    "mix"
    |> System.cmd(["compile"], cd: ExSync.Config.app_source_dir())
    |> log_compile_cmd()
  end

  def unload(module) when is_atom(module) do
    module |> :code.purge()
    module |> :code.delete()
  end

  def unload(beam_path) do
    beam_path |> Path.basename(".beam") |> String.to_atom() |> unload
  end

  # beam file path
  def reload(beam_path) do
    file = beam_path |> to_charlist
    {:ok, binary, _} = :erl_prim_loader.get_file(file)
    module = beam_path |> Path.basename(".beam") |> String.to_atom()
    :code.load_binary(module, file, binary)
  end

  defp log_compile_cmd({out, status} = result) when is_bitstring(out) and status > 0 do
    out |> Logger.info()
    result
  end

  defp log_compile_cmd(result), do: result
end
