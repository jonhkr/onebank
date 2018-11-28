defmodule OneBank.UserSchema do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Jason.Encoder, only: [:id, :name, :username, :inserted_at]}
  schema "user" do
    field :name
    field :username
    field :raw_password, :string, virtual: true
    field :password_hash

    timestamps()
  end

  @required_fields [:name, :username, :raw_password]

  def changeset(user, params \\ :empty) do
    user
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> put_change(:password_hash, hashpwsalt(params[:raw_password]))
  end
end
