require Logger

defmodule ExSync do
  defdelegate register_group_leader, to: ExSync.Logger.Server

  @doc """
  Accepts a MFA and calls the MFA after every code change

  Useful for testing code in a tight feedback loop
  """
  def set_reload_callback(module, function, argument) do
    Application.put_env(:exsync, :reload_callback, {module, function, argument})
  end
end
