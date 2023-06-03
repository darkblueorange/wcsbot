defmodule WcsBot.PartiesTest do
  use WcsBot.DataCase

  alias WcsBot.Parties

  describe "events" do
    alias WcsBot.Parties.Event

    import WcsBot.PartiesFixtures

    @invalid_attrs %{address: nil, begin_date: nil, country: nil, description: nil, end_date: nil, lineup: nil, name: nil, url_event: nil, wcsdc: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Parties.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Parties.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{address: "some address", begin_date: ~D[2023-06-02], country: "some country", description: "some description", end_date: ~D[2023-06-02], lineup: "some lineup", name: "some name", url_event: "some url_event", wcsdc: true}

      assert {:ok, %Event{} = event} = Parties.create_event(valid_attrs)
      assert event.address == "some address"
      assert event.begin_date == ~D[2023-06-02]
      assert event.country == "some country"
      assert event.description == "some description"
      assert event.end_date == ~D[2023-06-02]
      assert event.lineup == "some lineup"
      assert event.name == "some name"
      assert event.url_event == "some url_event"
      assert event.wcsdc == true
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parties.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{address: "some updated address", begin_date: ~D[2023-06-03], country: "some updated country", description: "some updated description", end_date: ~D[2023-06-03], lineup: "some updated lineup", name: "some updated name", url_event: "some updated url_event", wcsdc: false}

      assert {:ok, %Event{} = event} = Parties.update_event(event, update_attrs)
      assert event.address == "some updated address"
      assert event.begin_date == ~D[2023-06-03]
      assert event.country == "some updated country"
      assert event.description == "some updated description"
      assert event.end_date == ~D[2023-06-03]
      assert event.lineup == "some updated lineup"
      assert event.name == "some updated name"
      assert event.url_event == "some updated url_event"
      assert event.wcsdc == false
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Parties.update_event(event, @invalid_attrs)
      assert event == Parties.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Parties.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Parties.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Parties.change_event(event)
    end
  end
end
