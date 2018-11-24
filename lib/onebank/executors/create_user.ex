defimpl OneBank.CommandExecutor, for: OneBank.Command.CreateUser do

  alias OneBank.UserRepo

  def execute(command) do
    try do
      case UserRepo.create(command) do
        {:ok, user} -> user
        {:error, _} -> raise OneBank.InternalError # TODO: add details
      end
    catch
      _kind, %Ecto.ConstraintError{constraint: "idx_user_unique_username"} ->
        raise OneBank.ConflictError, details: %{username: ["has already been taken"]}
    end
  end
end
