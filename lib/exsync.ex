require Logger

defmodule ExSync do
  defdelegate register_group_leader, to: ExSync.Logger.Server
end
