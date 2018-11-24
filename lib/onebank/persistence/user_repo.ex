defmodule OneBank.UserRepo do
  require Logger
  import Ecto.Query, only: [from: 2]

  alias OneBank.{Command.CreateUser, User, Repo}

  @spec create(CreateUser.t()) :: term
  def create(create_user) do
    changeset = User.changeset(%User{}, Map.from_struct(create_user))

    Repo.insert(changeset)
  end

  @spec create(String.t()) :: term
  def find_by_username(username) do
    Repo.get_by(User, username: username)
  end
end
