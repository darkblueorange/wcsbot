defmodule WcsBotWeb.StrictlyAskingLive.Show do
  use WcsBotWeb, :live_view

  alias WcsBot.Competitions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:strictly_asking, Competitions.get_strictly_asking_with_preload!(id))}
  end

  defp page_title(:show), do: "Show Strictly asking"
  defp page_title(:edit), do: "Edit Strictly asking"
end
