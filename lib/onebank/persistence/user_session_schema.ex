defmodule OneBank.UserSessionSchema do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Jason.Encoder, only: [:id, :user_id, :inserted_at, :revoked_at]}
  schema "user_session" do
    field :user_id, Ecto.UUID
    field :revoke, :boolean, virtual: true
    field :revoked_at, :utc_datetime_usec

    timestamps()
  end

  @required_fields [:user_id]

  def changeset(user_session, params \\ :empty) do
    user_session
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> revoke_if_necessary(params[:revoke])
  end

  defp revoke_if_necessary(user_session, revoke) do
    if revoke do
      put_change(user_session, :revoked_at, DateTime.utc_now())
    end

    user_session
  end
end
