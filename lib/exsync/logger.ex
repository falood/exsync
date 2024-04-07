defmodule ExSync.Logger do
  require Logger

  def debug(message) do
    maybe_log(message, :debug)
  end

  def info(message) do
    maybe_log(message, :info)
  end

  def warning(message) do
    maybe_log(message, :warning)
  end

  def error(message) do
    maybe_log(message, :error)
  end

  defp maybe_log(message, level) do
    if ExSync.Config.logging_enabled() do
      Logger.log(level, ["[exsync] ", message])
    end
  end
end
