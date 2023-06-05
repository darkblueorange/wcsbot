defmodule WcsBot.Parties.SmallParty do
  use Ecto.Schema
  import Ecto.Changeset

  schema "small_parties" do
    field :address, :string
    field :begin_hour, :naive_datetime
    field :country, :string
    field :date, :date
    field :description, :string
    field :dj, :string
    field :end_hour, :naive_datetime
    field :fb_link, :string
    field :name, :string
    field :url_party, :string

    belongs_to(:dance_school, WcsBot.Teachings.DanceSchool)

    timestamps()
  end

  @doc false
  def changeset(small_party, attrs) do
    small_party
    |> cast(attrs, [
      :name,
      :date,
      :begin_hour,
      :end_hour,
      :address,
      :country,
      :description,
      :url_party,
      :fb_link,
      :dj,
      :dance_school_id
    ])
    |> validate_required([
      :name,
      :date,
      :begin_hour,
      :end_hour,
      :address,
      :country,
      :description,
      :url_party,
      :fb_link,
      :dj
    ])
    |> foreign_key_constraint(:dance_school_id)
  end
end
