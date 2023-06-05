defmodule WcsBotWeb.SmallPartyLiveTest do
  use WcsBotWeb.ConnCase

  import Phoenix.LiveViewTest
  import WcsBot.PartiesFixtures

  @create_attrs %{address: "some address", begin_hour: "2023-06-04T11:59:00", country: "some country", date: "2023-06-04", description: "some description", dj: "some dj", end_hour: "2023-06-04T11:59:00", fb_link: "some fb_link", name: "some name", url_party: "some url_party"}
  @update_attrs %{address: "some updated address", begin_hour: "2023-06-05T11:59:00", country: "some updated country", date: "2023-06-05", description: "some updated description", dj: "some updated dj", end_hour: "2023-06-05T11:59:00", fb_link: "some updated fb_link", name: "some updated name", url_party: "some updated url_party"}
  @invalid_attrs %{address: nil, begin_hour: nil, country: nil, date: nil, description: nil, dj: nil, end_hour: nil, fb_link: nil, name: nil, url_party: nil}

  defp create_small_party(_) do
    small_party = small_party_fixture()
    %{small_party: small_party}
  end

  describe "Index" do
    setup [:create_small_party]

    test "lists all small_parties", %{conn: conn, small_party: small_party} do
      {:ok, _index_live, html} = live(conn, ~p"/small_parties")

      assert html =~ "Listing Small parties"
      assert html =~ small_party.address
    end

    test "saves new small_party", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/small_parties")

      assert index_live |> element("a", "New Small party") |> render_click() =~
               "New Small party"

      assert_patch(index_live, ~p"/small_parties/new")

      assert index_live
             |> form("#small_party-form", small_party: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#small_party-form", small_party: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/small_parties")

      html = render(index_live)
      assert html =~ "Small party created successfully"
      assert html =~ "some address"
    end

    test "updates small_party in listing", %{conn: conn, small_party: small_party} do
      {:ok, index_live, _html} = live(conn, ~p"/small_parties")

      assert index_live |> element("#small_parties-#{small_party.id} a", "Edit") |> render_click() =~
               "Edit Small party"

      assert_patch(index_live, ~p"/small_parties/#{small_party}/edit")

      assert index_live
             |> form("#small_party-form", small_party: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#small_party-form", small_party: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/small_parties")

      html = render(index_live)
      assert html =~ "Small party updated successfully"
      assert html =~ "some updated address"
    end

    test "deletes small_party in listing", %{conn: conn, small_party: small_party} do
      {:ok, index_live, _html} = live(conn, ~p"/small_parties")

      assert index_live |> element("#small_parties-#{small_party.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#small_parties-#{small_party.id}")
    end
  end

  describe "Show" do
    setup [:create_small_party]

    test "displays small_party", %{conn: conn, small_party: small_party} do
      {:ok, _show_live, html} = live(conn, ~p"/small_parties/#{small_party}")

      assert html =~ "Show Small party"
      assert html =~ small_party.address
    end

    test "updates small_party within modal", %{conn: conn, small_party: small_party} do
      {:ok, show_live, _html} = live(conn, ~p"/small_parties/#{small_party}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Small party"

      assert_patch(show_live, ~p"/small_parties/#{small_party}/show/edit")

      assert show_live
             |> form("#small_party-form", small_party: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#small_party-form", small_party: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/small_parties/#{small_party}")

      html = render(show_live)
      assert html =~ "Small party updated successfully"
      assert html =~ "some updated address"
    end
  end
end
