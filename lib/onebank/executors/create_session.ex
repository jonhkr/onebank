defimpl OneBank.CommandExecutor, for: OneBank.Command.CreateSession do

  require Logger

  alias OneBank.{UserRepo, UserSessionRepo}

  import Comeonin.Bcrypt, only: [checkpw: 2]

  def execute(command) do
    user = UserRepo.find_by_username(command.username)

    if user == nil do
      raise OneBank.AuthenticationError
    end

    if checkpw(command.raw_password, user.password_hash) do
      create_session(user)
    else
      raise OneBank.AuthenticationError
    end
  end

  defp create_session(user) do
    case UserSessionRepo.create(user) do
      {:ok, user_session} -> user_session
      {:error, _} -> raise OneBank.InternalError # TODO: add details
    end
  end
end
