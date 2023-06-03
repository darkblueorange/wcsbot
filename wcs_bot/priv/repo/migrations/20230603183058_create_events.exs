defmodule WcsBot.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :begin_date, :date
      add :end_date, :date
      add :address, :string
      add :country, :string
      add :lineup, :string
      add :description, :string
      add :url_event, :string
      add :wcsdc, :boolean, default: false, null: false
      add :dance_school_id, references(:dance_schools, on_delete: :nothing)

      timestamps()
    end

    create index(:events, [:dance_school_id])
  end
end
