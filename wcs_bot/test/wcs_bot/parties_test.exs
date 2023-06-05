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

  describe "small_parties" do
    alias WcsBot.Parties.SmallParty

    import WcsBot.PartiesFixtures

    @invalid_attrs %{address: nil, begin_hour: nil, country: nil, date: nil, description: nil, dj: nil, end_hour: nil, fb_link: nil, name: nil, url_party: nil}

    test "list_small_parties/0 returns all small_parties" do
      small_party = small_party_fixture()
      assert Parties.list_small_parties() == [small_party]
    end

    test "get_small_party!/1 returns the small_party with given id" do
      small_party = small_party_fixture()
      assert Parties.get_small_party!(small_party.id) == small_party
    end

    test "create_small_party/1 with valid data creates a small_party" do
      valid_attrs = %{address: "some address", begin_hour: ~N[2023-06-04 11:59:00], country: "some country", date: ~D[2023-06-04], description: "some description", dj: "some dj", end_hour: ~N[2023-06-04 11:59:00], fb_link: "some fb_link", name: "some name", url_party: "some url_party"}

      assert {:ok, %SmallParty{} = small_party} = Parties.create_small_party(valid_attrs)
      assert small_party.address == "some address"
      assert small_party.begin_hour == ~N[2023-06-04 11:59:00]
      assert small_party.country == "some country"
      assert small_party.date == ~D[2023-06-04]
      assert small_party.description == "some description"
      assert small_party.dj == "some dj"
      assert small_party.end_hour == ~N[2023-06-04 11:59:00]
      assert small_party.fb_link == "some fb_link"
      assert small_party.name == "some name"
      assert small_party.url_party == "some url_party"
    end

    test "create_small_party/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Parties.create_small_party(@invalid_attrs)
    end

    test "update_small_party/2 with valid data updates the small_party" do
      small_party = small_party_fixture()
      update_attrs = %{address: "some updated address", begin_hour: ~N[2023-06-05 11:59:00], country: "some updated country", date: ~D[2023-06-05], description: "some updated description", dj: "some updated dj", end_hour: ~N[2023-06-05 11:59:00], fb_link: "some updated fb_link", name: "some updated name", url_party: "some updated url_party"}

      assert {:ok, %SmallParty{} = small_party} = Parties.update_small_party(small_party, update_attrs)
      assert small_party.address == "some updated address"
      assert small_party.begin_hour == ~N[2023-06-05 11:59:00]
      assert small_party.country == "some updated country"
      assert small_party.date == ~D[2023-06-05]
      assert small_party.description == "some updated description"
      assert small_party.dj == "some updated dj"
      assert small_party.end_hour == ~N[2023-06-05 11:59:00]
      assert small_party.fb_link == "some updated fb_link"
      assert small_party.name == "some updated name"
      assert small_party.url_party == "some updated url_party"
    end

    test "update_small_party/2 with invalid data returns error changeset" do
      small_party = small_party_fixture()
      assert {:error, %Ecto.Changeset{}} = Parties.update_small_party(small_party, @invalid_attrs)
      assert small_party == Parties.get_small_party!(small_party.id)
    end

    test "delete_small_party/1 deletes the small_party" do
      small_party = small_party_fixture()
      assert {:ok, %SmallParty{}} = Parties.delete_small_party(small_party)
      assert_raise Ecto.NoResultsError, fn -> Parties.get_small_party!(small_party.id) end
    end

    test "change_small_party/1 returns a small_party changeset" do
      small_party = small_party_fixture()
      assert %Ecto.Changeset{} = Parties.change_small_party(small_party)
    end
  end
end
