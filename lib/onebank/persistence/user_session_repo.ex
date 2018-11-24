defmodule OneBank.UserSessionRepo do
  require Logger
  import Ecto.Query, only: [from: 2]

  alias OneBank.{UserSession, User, Repo}

  @spec create(User.t()) :: term
  def create(user) do
    changeset = UserSession.changeset(%UserSession{}, %{user_id: user.id})

    IO.puts(inspect changeset)

    Repo.insert(changeset)
  end
end
