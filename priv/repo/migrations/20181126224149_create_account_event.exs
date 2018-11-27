defmodule OneBank.Repo.Migrations.CreateAccountEvent do
  use Ecto.Migration

  def change do
    create table(:account_event) do
      add(:account_id, references(:account, type: :uuid))
      add(:correlation_id, :uuid)
      add(:type, :string, null: false)
      add(:meta, :map)
      timestamps(updated_at: false)
    end
  end
end
