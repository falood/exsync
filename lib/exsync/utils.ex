defmodule ExSync.Utils do
  def recomplete do
    ExSync.Logger.debug("running mix compile\n")

    System.cmd("mix", ["compile"], cd: ExSync.Config.app_source_dir())
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

  defp log_compile_cmd({output, status} = result) when is_binary(output) and status > 0 do
    ExSync.Logger.error(["error while compiling\n", output, "\n"])
    result
  end

  defp log_compile_cmd({"", _status} = result), do: result

  defp log_compile_cmd({output, _status} = result) when is_binary(output) do
    message = ["compiling\n", output]

    if String.contains?(output, "warning:") do
      ExSync.Logger.warn(message)
    else
      ExSync.Logger.debug(message)
    end

    result
  end
end
