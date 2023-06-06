defmodule WcsBotWeb.StrictlyAskingLiveTest do
  use WcsBotWeb.ConnCase

  import Phoenix.LiveViewTest
  import WcsBot.CompetitionsFixtures

  @create_attrs %{asking_filled: true, dancing_role: "some dancing_role", description: "some description", discord_tag: "some discord_tag", name: "some name", wcsdc_level: "some wcsdc_level"}
  @update_attrs %{asking_filled: false, dancing_role: "some updated dancing_role", description: "some updated description", discord_tag: "some updated discord_tag", name: "some updated name", wcsdc_level: "some updated wcsdc_level"}
  @invalid_attrs %{asking_filled: false, dancing_role: nil, description: nil, discord_tag: nil, name: nil, wcsdc_level: nil}

  defp create_strictly_asking(_) do
    strictly_asking = strictly_asking_fixture()
    %{strictly_asking: strictly_asking}
  end

  describe "Index" do
    setup [:create_strictly_asking]

    test "lists all strictly_askings", %{conn: conn, strictly_asking: strictly_asking} do
      {:ok, _index_live, html} = live(conn, ~p"/strictly_askings")

      assert html =~ "Listing Strictly askings"
      assert html =~ strictly_asking.dancing_role
    end

    test "saves new strictly_asking", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/strictly_askings")

      assert index_live |> element("a", "New Strictly asking") |> render_click() =~
               "New Strictly asking"

      assert_patch(index_live, ~p"/strictly_askings/new")

      assert index_live
             |> form("#strictly_asking-form", strictly_asking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#strictly_asking-form", strictly_asking: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/strictly_askings")

      html = render(index_live)
      assert html =~ "Strictly asking created successfully"
      assert html =~ "some dancing_role"
    end

    test "updates strictly_asking in listing", %{conn: conn, strictly_asking: strictly_asking} do
      {:ok, index_live, _html} = live(conn, ~p"/strictly_askings")

      assert index_live |> element("#strictly_askings-#{strictly_asking.id} a", "Edit") |> render_click() =~
               "Edit Strictly asking"

      assert_patch(index_live, ~p"/strictly_askings/#{strictly_asking}/edit")

      assert index_live
             |> form("#strictly_asking-form", strictly_asking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#strictly_asking-form", strictly_asking: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/strictly_askings")

      html = render(index_live)
      assert html =~ "Strictly asking updated successfully"
      assert html =~ "some updated dancing_role"
    end

    test "deletes strictly_asking in listing", %{conn: conn, strictly_asking: strictly_asking} do
      {:ok, index_live, _html} = live(conn, ~p"/strictly_askings")

      assert index_live |> element("#strictly_askings-#{strictly_asking.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#strictly_askings-#{strictly_asking.id}")
    end
  end

  describe "Show" do
    setup [:create_strictly_asking]

    test "displays strictly_asking", %{conn: conn, strictly_asking: strictly_asking} do
      {:ok, _show_live, html} = live(conn, ~p"/strictly_askings/#{strictly_asking}")

      assert html =~ "Show Strictly asking"
      assert html =~ strictly_asking.dancing_role
    end

    test "updates strictly_asking within modal", %{conn: conn, strictly_asking: strictly_asking} do
      {:ok, show_live, _html} = live(conn, ~p"/strictly_askings/#{strictly_asking}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Strictly asking"

      assert_patch(show_live, ~p"/strictly_askings/#{strictly_asking}/show/edit")

      assert show_live
             |> form("#strictly_asking-form", strictly_asking: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#strictly_asking-form", strictly_asking: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/strictly_askings/#{strictly_asking}")

      html = render(show_live)
      assert html =~ "Strictly asking updated successfully"
      assert html =~ "some updated dancing_role"
    end
  end
end
