defmodule OneBank.Repo.Migrations.CreateIban do
  use Ecto.Migration

  def change do
    create table(:iban) do
      add(:account_id, :uuid, null: false)
      add(:number, :string, null: false)

      timestamps()
    end

    create(unique_index(:iban, [:number], name: :idx_iban_unique_number))
  end
end
