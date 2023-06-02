defmodule WcsBot.TeachingsTest do
  use WcsBot.DataCase

  alias WcsBot.Teachings

  describe "dance_schools" do
    alias WcsBot.Teachings.DanceSchool

    import WcsBot.TeachingsFixtures

    @invalid_attrs %{boss: nil, city: nil, country: nil, name: nil}

    test "list_dance_schools/0 returns all dance_schools" do
      dance_school = dance_school_fixture()
      assert Teachings.list_dance_schools() == [dance_school]
    end

    test "get_dance_school!/1 returns the dance_school with given id" do
      dance_school = dance_school_fixture()
      assert Teachings.get_dance_school!(dance_school.id) == dance_school
    end

    test "create_dance_school/1 with valid data creates a dance_school" do
      valid_attrs = %{boss: "some boss", city: "some city", country: "some country", name: "some name"}

      assert {:ok, %DanceSchool{} = dance_school} = Teachings.create_dance_school(valid_attrs)
      assert dance_school.boss == "some boss"
      assert dance_school.city == "some city"
      assert dance_school.country == "some country"
      assert dance_school.name == "some name"
    end

    test "create_dance_school/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teachings.create_dance_school(@invalid_attrs)
    end

    test "update_dance_school/2 with valid data updates the dance_school" do
      dance_school = dance_school_fixture()
      update_attrs = %{boss: "some updated boss", city: "some updated city", country: "some updated country", name: "some updated name"}

      assert {:ok, %DanceSchool{} = dance_school} = Teachings.update_dance_school(dance_school, update_attrs)
      assert dance_school.boss == "some updated boss"
      assert dance_school.city == "some updated city"
      assert dance_school.country == "some updated country"
      assert dance_school.name == "some updated name"
    end

    test "update_dance_school/2 with invalid data returns error changeset" do
      dance_school = dance_school_fixture()
      assert {:error, %Ecto.Changeset{}} = Teachings.update_dance_school(dance_school, @invalid_attrs)
      assert dance_school == Teachings.get_dance_school!(dance_school.id)
    end

    test "delete_dance_school/1 deletes the dance_school" do
      dance_school = dance_school_fixture()
      assert {:ok, %DanceSchool{}} = Teachings.delete_dance_school(dance_school)
      assert_raise Ecto.NoResultsError, fn -> Teachings.get_dance_school!(dance_school.id) end
    end

    test "change_dance_school/1 returns a dance_school changeset" do
      dance_school = dance_school_fixture()
      assert %Ecto.Changeset{} = Teachings.change_dance_school(dance_school)
    end
  end
end
