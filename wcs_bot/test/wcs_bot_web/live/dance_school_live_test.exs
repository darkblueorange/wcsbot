defmodule WcsBotWeb.DanceSchoolLiveTest do
  use WcsBotWeb.ConnCase

  import Phoenix.LiveViewTest
  import WcsBot.TeachingsFixtures

  @create_attrs %{boss: "some boss", city: "some city", country: "some country", name: "some name"}
  @update_attrs %{boss: "some updated boss", city: "some updated city", country: "some updated country", name: "some updated name"}
  @invalid_attrs %{boss: nil, city: nil, country: nil, name: nil}

  defp create_dance_school(_) do
    dance_school = dance_school_fixture()
    %{dance_school: dance_school}
  end

  describe "Index" do
    setup [:create_dance_school]

    test "lists all dance_schools", %{conn: conn, dance_school: dance_school} do
      {:ok, _index_live, html} = live(conn, ~p"/dance_schools")

      assert html =~ "Listing Dance schools"
      assert html =~ dance_school.boss
    end

    test "saves new dance_school", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/dance_schools")

      assert index_live |> element("a", "New Dance school") |> render_click() =~
               "New Dance school"

      assert_patch(index_live, ~p"/dance_schools/new")

      assert index_live
             |> form("#dance_school-form", dance_school: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dance_school-form", dance_school: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dance_schools")

      html = render(index_live)
      assert html =~ "Dance school created successfully"
      assert html =~ "some boss"
    end

    test "updates dance_school in listing", %{conn: conn, dance_school: dance_school} do
      {:ok, index_live, _html} = live(conn, ~p"/dance_schools")

      assert index_live |> element("#dance_schools-#{dance_school.id} a", "Edit") |> render_click() =~
               "Edit Dance school"

      assert_patch(index_live, ~p"/dance_schools/#{dance_school}/edit")

      assert index_live
             |> form("#dance_school-form", dance_school: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#dance_school-form", dance_school: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dance_schools")

      html = render(index_live)
      assert html =~ "Dance school updated successfully"
      assert html =~ "some updated boss"
    end

    test "deletes dance_school in listing", %{conn: conn, dance_school: dance_school} do
      {:ok, index_live, _html} = live(conn, ~p"/dance_schools")

      assert index_live |> element("#dance_schools-#{dance_school.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#dance_schools-#{dance_school.id}")
    end
  end

  describe "Show" do
    setup [:create_dance_school]

    test "displays dance_school", %{conn: conn, dance_school: dance_school} do
      {:ok, _show_live, html} = live(conn, ~p"/dance_schools/#{dance_school}")

      assert html =~ "Show Dance school"
      assert html =~ dance_school.boss
    end

    test "updates dance_school within modal", %{conn: conn, dance_school: dance_school} do
      {:ok, show_live, _html} = live(conn, ~p"/dance_schools/#{dance_school}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Dance school"

      assert_patch(show_live, ~p"/dance_schools/#{dance_school}/show/edit")

      assert show_live
             |> form("#dance_school-form", dance_school: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#dance_school-form", dance_school: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/dance_schools/#{dance_school}")

      html = render(show_live)
      assert html =~ "Dance school updated successfully"
      assert html =~ "some updated boss"
    end
  end
end
