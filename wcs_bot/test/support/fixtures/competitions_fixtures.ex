defmodule WcsBot.CompetitionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WcsBot.Competitions` context.
  """

  @doc """
  Generate a strictly_asking.
  """
  def strictly_asking_fixture(attrs \\ %{}) do
    {:ok, strictly_asking} =
      attrs
      |> Enum.into(%{
        asking_filled: true,
        dancing_role: "some dancing_role",
        description: "some description",
        discord_tag: "some discord_tag",
        name: "some name",
        wcsdc_level: "some wcsdc_level"
      })
      |> WcsBot.Competitions.create_strictly_asking()

    strictly_asking
  end
end
