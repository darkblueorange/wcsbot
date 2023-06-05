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

  @doc """
  Generate a small_party.
  """
  def small_party_fixture(attrs \\ %{}) do
    {:ok, small_party} =
      attrs
      |> Enum.into(%{
        address: "some address",
        begin_hour: ~N[2023-06-04 11:59:00],
        country: "some country",
        date: ~D[2023-06-04],
        description: "some description",
        dj: "some dj",
        end_hour: ~N[2023-06-04 11:59:00],
        fb_link: "some fb_link",
        name: "some name",
        url_party: "some url_party"
      })
      |> WcsBot.Parties.create_small_party()

    small_party
  end
end
