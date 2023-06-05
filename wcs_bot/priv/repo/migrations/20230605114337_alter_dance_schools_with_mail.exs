defmodule WcsBot.Repo.Migrations.AlterDanceSchoolsWithMailAndWebsiteUrl do
  use Ecto.Migration

  def change do
    alter table(:dance_schools) do
      add :mail, :string
      add :website_url, :string
    end
  end
end
