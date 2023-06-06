defmodule WcsBot.Competitions.StrictlyAsking do
  @moduledoc """
  Competitions.StrictlyAsking schema. Represents a Strictly Ask.
  Is linked to an event

  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "strictly_askings" do
    field(:asking_filled, :boolean, default: false)
    field(:dancing_role, :string)
    field(:description, :string)
    field(:discord_tag, :string)
    field(:name, :string)
    field(:wcsdc_level, :string)

    belongs_to(:event, WcsBot.Parties.Event)

    timestamps()
  end

  @doc false
  def changeset(strictly_asking, attrs) do
    strictly_asking
    |> cast(attrs, [
      :name,
      :wcsdc_level,
      :description,
      :asking_filled,
      :dancing_role,
      :discord_tag,
      :event_id
    ])
    |> validate_required([
      :name,
      :wcsdc_level,
      :description,
      :asking_filled,
      :dancing_role,
      :discord_tag
    ])
    |> foreign_key_constraint(:event_id)
  end
end
