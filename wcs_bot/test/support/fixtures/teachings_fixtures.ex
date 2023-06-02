defmodule WcsBot.TeachingsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WcsBot.Teachings` context.
  """

  @doc """
  Generate a dance_school.
  """
  def dance_school_fixture(attrs \\ %{}) do
    {:ok, dance_school} =
      attrs
      |> Enum.into(%{
        boss: "some boss",
        city: "some city",
        country: "some country",
        name: "some name"
      })
      |> WcsBot.Teachings.create_dance_school()

    dance_school
  end
end
