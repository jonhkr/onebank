defmodule OneBank.UserSessionRepo do
  require Logger

  alias OneBank.{UserSessionSchema, UserSchema, Repo}

  @spec create(UserSchema.t()) :: term
  def create(user) do
    UserSessionSchema.changeset(%UserSessionSchema{}, %{user_id: user.id})
    |> Repo.insert
  end
end
