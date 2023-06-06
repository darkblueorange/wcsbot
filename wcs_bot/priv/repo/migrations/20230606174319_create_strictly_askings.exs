defmodule WcsBot.Repo.Migrations.CreateStrictlyAskings do
  use Ecto.Migration

  def change do
    create table(:strictly_askings) do
      add :name, :string
      add :wcsdc_level, :string
      add :description, :string
      add :asking_filled, :boolean, default: false, null: false
      add :dancing_role, :string
      add :discord_tag, :string
      add :event_id, references(:events, on_delete: :nothing)

      timestamps()
    end

    create index(:strictly_askings, [:event_id])
  end
end
