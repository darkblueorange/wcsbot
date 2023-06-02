defmodule WcsBotWeb.DanceSchoolLive.Show do
  use WcsBotWeb, :live_view

  alias WcsBot.Teachings

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:dance_school, Teachings.get_dance_school!(id))}
  end

  defp page_title(:show), do: "Show Dance school"
  defp page_title(:edit), do: "Edit Dance school"
end
