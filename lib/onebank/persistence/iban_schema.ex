defmodule OneBank.IbanSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "iban" do
    field :number
    field :account_id, Ecto.UUID

    timestamps()
  end

  @required_fields [:number, :account_id]

  def changeset(user, params \\ :empty) do
    user
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end
end
