defmodule WcsBot.Repo.Migrations.CreateSmallParties do
  use Ecto.Migration

  def change do
    create table(:small_parties) do
      add :name, :string
      add :party_date, :date
      add :begin_hour, :naive_datetime
      add :end_hour, :naive_datetime
      add :address, :string
      add :city, :string
      add :country, :string
      add :description, :string
      add :url_party, :string
      add :fb_link, :string
      add :dj, :string
      add :dance_school_id, references(:dance_schools, on_delete: :nothing)

      timestamps()
    end

    create index(:small_parties, [:dance_school_id])
  end
end
