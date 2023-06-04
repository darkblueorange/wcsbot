defmodule WcsBot.Teachings.DanceSchool do
  @moduledoc """
  DanceSchool schema. Represents a dance school.
  Will be linked to a Studio soon.

  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "dance_schools" do
    field :boss, :string
    field :city, :string
    field :country, :string
    field :name, :string

    # If we delete a dance_school linked to an Event, we this the latter oprhan (instead deleting it: nilify_all instead of the usual delete_all)
    has_many(:events, WcsBot.Parties.Event, on_delete: :nilify_all)

    timestamps()
  end

  @doc false
  def changeset(dance_school, attrs) do
    dance_school
    |> cast(attrs, [:name, :city, :country, :boss])
    |> validate_required([:name, :city, :country, :boss])
    |> unique_constraint(:name)
  end
end
