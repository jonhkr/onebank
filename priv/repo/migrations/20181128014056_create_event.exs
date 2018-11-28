defmodule OneBank.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:event, primary_key: false) do
      add(:aggregate_id, :uuid, null: false)
      add(:aggregate_type, :string, null: false)
      add(:version, :integer, null: false)
      add(:event_type, :string, null: false)
      add(:event_data, :map)

      timestamps(updated_at: false)
    end

    create(unique_index(:event,[:aggregate_id, :aggregate_type, :version],
      name: :unique_aggregate_id_type_and_version))
  end
end
