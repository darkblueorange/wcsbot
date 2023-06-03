defmodule WcsBot.Repo.Migrations.AlterDanceSchools do
  use Ecto.Migration

  def change do
    # trying to add unique index on DanceSchools based on names
    create unique_index(:dance_schools, [:name])
  end
end
