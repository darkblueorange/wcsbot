defmodule WcsBot.PartiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `WcsBot.Parties` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        address: "some address",
        begin_date: ~D[2023-06-02],
        country: "some country",
        description: "some description",
        end_date: ~D[2023-06-02],
        lineup: "some lineup",
        name: "some name",
        url_event: "some url_event",
        wcsdc: true
      })
      |> WcsBot.Parties.create_event()

    event
  end
end
