defmodule OneBank.AccountEventSchema do
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id

  schema "account_event" do
    belongs_to :account, AccountSchema
    field :correlation_id, Ecto.UUID
    field :type
    field :meta, :map

    timestamps()
  end

  @required_fields [:account_id, :type, :meta]

  def changeset(event, params \\ :empty) do
    event
    |> cast(params, @required_fields ++ [:correlation_id])
    |> validate_required(@required_fields)
  end
end
