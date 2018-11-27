defmodule OneBank.AccountSchema do
  use Ecto.Schema
  import Ecto.Changeset

  alias OneBank.AccountEventSchema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Jason.Encoder, only: [:id, :iban, :user_id, :currency, :balance]}
  schema "account" do
    field :version, :integer, default: 1
    field :iban
    field :user_id, Ecto.UUID
    field :currency
    field :balance, :decimal, default: 0
    has_many :events, AccountEventSchema, foreign_key: :account_id

    timestamps()
  end

  @required_fields [:iban, :user_id, :currency]

  def changeset(op, account, params \\ :empty)

  def changeset(:create, account, params) do
    account
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  def changeset(:update, account, params) do
    account
    |> cast(params, [:balance])
    |> validate_number(:balance, greater_than_or_equal_to: 0)
    |> optimistic_lock(:version)
  end
end
