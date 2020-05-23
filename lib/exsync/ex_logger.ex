defmodule ExSync.Logger do
  alias ExSync.Logger.Server
  defdelegate log(message), to: Server
end
