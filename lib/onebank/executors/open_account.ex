defimpl OneBank.CommandExecutor, for: OneBank.Command.OpenAccount do

  alias OneBank.AccountRepo

  def execute(command) do
    case AccountRepo.create(command) do
      {:ok, account} -> account
      {:error, _} -> raise OneBank.InternalError # TODO: add details
    end
  end
end
