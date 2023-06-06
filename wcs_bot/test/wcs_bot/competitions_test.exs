defmodule WcsBot.CompetitionsTest do
  use WcsBot.DataCase

  alias WcsBot.Competitions

  describe "strictly_askings" do
    alias WcsBot.Competitions.StrictlyAsking

    import WcsBot.CompetitionsFixtures

    @invalid_attrs %{asking_filled: nil, dancing_role: nil, description: nil, discord_tag: nil, name: nil, wcsdc_level: nil}

    test "list_strictly_askings/0 returns all strictly_askings" do
      strictly_asking = strictly_asking_fixture()
      assert Competitions.list_strictly_askings() == [strictly_asking]
    end

    test "get_strictly_asking!/1 returns the strictly_asking with given id" do
      strictly_asking = strictly_asking_fixture()
      assert Competitions.get_strictly_asking!(strictly_asking.id) == strictly_asking
    end

    test "create_strictly_asking/1 with valid data creates a strictly_asking" do
      valid_attrs = %{asking_filled: true, dancing_role: "some dancing_role", description: "some description", discord_tag: "some discord_tag", name: "some name", wcsdc_level: "some wcsdc_level"}

      assert {:ok, %StrictlyAsking{} = strictly_asking} = Competitions.create_strictly_asking(valid_attrs)
      assert strictly_asking.asking_filled == true
      assert strictly_asking.dancing_role == "some dancing_role"
      assert strictly_asking.description == "some description"
      assert strictly_asking.discord_tag == "some discord_tag"
      assert strictly_asking.name == "some name"
      assert strictly_asking.wcsdc_level == "some wcsdc_level"
    end

    test "create_strictly_asking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Competitions.create_strictly_asking(@invalid_attrs)
    end

    test "update_strictly_asking/2 with valid data updates the strictly_asking" do
      strictly_asking = strictly_asking_fixture()
      update_attrs = %{asking_filled: false, dancing_role: "some updated dancing_role", description: "some updated description", discord_tag: "some updated discord_tag", name: "some updated name", wcsdc_level: "some updated wcsdc_level"}

      assert {:ok, %StrictlyAsking{} = strictly_asking} = Competitions.update_strictly_asking(strictly_asking, update_attrs)
      assert strictly_asking.asking_filled == false
      assert strictly_asking.dancing_role == "some updated dancing_role"
      assert strictly_asking.description == "some updated description"
      assert strictly_asking.discord_tag == "some updated discord_tag"
      assert strictly_asking.name == "some updated name"
      assert strictly_asking.wcsdc_level == "some updated wcsdc_level"
    end

    test "update_strictly_asking/2 with invalid data returns error changeset" do
      strictly_asking = strictly_asking_fixture()
      assert {:error, %Ecto.Changeset{}} = Competitions.update_strictly_asking(strictly_asking, @invalid_attrs)
      assert strictly_asking == Competitions.get_strictly_asking!(strictly_asking.id)
    end

    test "delete_strictly_asking/1 deletes the strictly_asking" do
      strictly_asking = strictly_asking_fixture()
      assert {:ok, %StrictlyAsking{}} = Competitions.delete_strictly_asking(strictly_asking)
      assert_raise Ecto.NoResultsError, fn -> Competitions.get_strictly_asking!(strictly_asking.id) end
    end

    test "change_strictly_asking/1 returns a strictly_asking changeset" do
      strictly_asking = strictly_asking_fixture()
      assert %Ecto.Changeset{} = Competitions.change_strictly_asking(strictly_asking)
    end
  end
end
