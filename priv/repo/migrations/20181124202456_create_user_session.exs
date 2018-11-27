defmodule OneBank.Repo.Migrations.CreateUserSession do
  use Ecto.Migration

  def change do
    create table(:user_session, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:user, type: :uuid), null: false)
      add(:revoked_at, :utc_datetime_usec)

      timestamps()
    end
  end
end
