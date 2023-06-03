defmodule WcsBot.Parties.Event do
  @moduledoc """
  Parties.Event schema. Represents an event.
  Is optionally linked to a DanceSchool

  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :address, :string
    field :begin_date, :date
    field :country, :string
    field :description, :string
    field :end_date, :date
    field :lineup, :string
    field :name, :string
    field :url_event, :string
    field :wcsdc, :boolean, default: false

    belongs_to(:dance_school, WcsBot.Teachings.DanceSchool)

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :name,
      :begin_date,
      :end_date,
      :address,
      :country,
      :lineup,
      :description,
      :url_event,
      :wcsdc,
      :dance_school_id
    ])
    |> validate_required([
      :name,
      :begin_date,
      :end_date,
      :address,
      :country,
      :lineup,
      :description,
      :url_event,
      :wcsdc
    ])
    |> foreign_key_constraint(:dance_school_id)
  end
end
