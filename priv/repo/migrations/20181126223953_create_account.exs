defmodule OneBank.Repo.Migrations.CreateAccount do
  use Ecto.Migration

  def change do
    create table(:account, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:iban, :string, unique: true, size: 29, null: false)
      add(:user_id, references(:user, type: :uuid), null: false)
      add(:version, :integer, default: 1)
      add(:balance, :decimal, precision: 13, scale: 4)
      add(:currency, :string, size: 3, null: false)
      timestamps()
    end

    create(unique_index(:account, [:user_id, :currency], name: :idx_account_unique_user_currency))
  end
end
