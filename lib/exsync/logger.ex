defmodule ExSync.Logger do
  alias ExSync.Logger.Server
  defdelegate debug(message), to: Server
  defdelegate error(message), to: Server
end
