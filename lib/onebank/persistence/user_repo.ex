defmodule OneBank.UserRepo do
  require Logger

  alias OneBank.{Command.CreateUser, UserSchema, Repo}

  @spec create(CreateUser.t()) :: term
  def create(create_user) do
    changeset = UserSchema.changeset(%UserSchema{}, Map.from_struct(create_user))

    Repo.insert(changeset)
  end

  @spec create(String.t()) :: term
  def find_by_username(username) do
    Repo.get_by(UserSchema, username: username)
  end
end
