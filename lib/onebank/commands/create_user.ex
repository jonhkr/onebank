defmodule OneBank.Command.CreateUser do

  defstruct name: nil, username: nil, raw_password: nil

  use Vex.Struct

  validates :name, presence: true
  validates :username, presence: true,
                       length: [min: 4]
  validates :raw_password, presence: true,
                           length: [min: 6]


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
end
