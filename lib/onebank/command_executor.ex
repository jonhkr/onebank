defprotocol OneBank.CommandExecutor do
	@moduledoc """
  A protocl for executing commands.

  """

  @typedoc "The command"
  @type command :: struct

	@doc """
  Receives a validated command and executes it.
  
  """
  @spec execute(command) :: term
  def execute(command)
end
