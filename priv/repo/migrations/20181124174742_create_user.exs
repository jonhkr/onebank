defmodule OneBank.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:username, :string, unique: true, null: false)
      add(:password_hash, :string, null: false)

      timestamps()
    end

    create(unique_index(:user, [:username], name: :idx_user_unique_username))
  end
end
