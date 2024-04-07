require Logger

defmodule ExSync do
  def register_group_leader do
    Logger.debug(
      "[exsync] Adding ExSync to your .iex.exs is no longer necessary. " <>
        "You can remove the call ExSync.register_group_leader/0 now."
    )

    :ok
  end
end
