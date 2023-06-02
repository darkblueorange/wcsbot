defmodule WcsBot.Teachings.DanceSchool do
  use Ecto.Schema
  import Ecto.Changeset

  schema "dance_schools" do
    field :boss, :string
    field :city, :string
    field :country, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(dance_school, attrs) do
    dance_school
    |> cast(attrs, [:name, :city, :country, :boss])
    |> validate_required([:name, :city, :country, :boss])
  end
end
