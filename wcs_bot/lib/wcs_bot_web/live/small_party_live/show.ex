defmodule WcsBotWeb.SmallPartyLive.Show do
  use WcsBotWeb, :live_view

  alias WcsBot.Parties

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:small_party, Parties.get_small_party_with_preload!(id))}
  end

  defp page_title(:show), do: "Show Small party"
  defp page_title(:edit), do: "Edit Small party"
end
