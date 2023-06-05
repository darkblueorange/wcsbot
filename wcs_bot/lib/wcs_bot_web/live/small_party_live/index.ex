defmodule WcsBotWeb.SmallPartyLive.Index do
  use WcsBotWeb, :live_view

  alias WcsBot.Parties
  alias WcsBot.Parties.SmallParty

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :small_parties, Parties.list_small_parties_with_preload())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Small party")
    |> assign(:small_party, Parties.get_small_party_with_preload!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Small party")
    |> assign(:small_party, %SmallParty{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Small parties")
    |> assign(:small_party, nil)
  end

  @impl true
  def handle_info({WcsBotWeb.SmallPartyLive.FormComponent, {:saved, small_party}}, socket) do
    {:noreply, stream_insert(socket, :small_parties, small_party)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    small_party = Parties.get_small_party!(id)
    {:ok, _} = Parties.delete_small_party(small_party)

    {:noreply, stream_delete(socket, :small_parties, small_party)}
  end
end
