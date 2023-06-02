defmodule WcsBot.Repo.Migrations.CreateDanceSchools do
  use Ecto.Migration

  def change do
    create table(:dance_schools) do
      add :name, :string
      add :city, :string
      add :country, :string
      add :boss, :string

      timestamps()
    end
  end
end
