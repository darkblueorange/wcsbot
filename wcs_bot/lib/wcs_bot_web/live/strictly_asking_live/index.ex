defmodule WcsBotWeb.StrictlyAskingLive.Index do
  use WcsBotWeb, :live_view

  alias WcsBot.Competitions
  alias WcsBot.Competitions.StrictlyAsking

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :strictly_askings, Competitions.list_strictly_askings_with_preload())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Strictly asking")
    |> assign(:strictly_asking, Competitions.get_strictly_asking_with_preload!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Strictly asking")
    |> assign(:strictly_asking, %StrictlyAsking{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Strictly askings")
    |> assign(:strictly_asking, nil)
  end

  @impl true
  def handle_info({WcsBotWeb.StrictlyAskingLive.FormComponent, {:saved, strictly_asking}}, socket) do
    {:noreply, stream_insert(socket, :strictly_askings, strictly_asking)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    strictly_asking = Competitions.get_strictly_asking!(id)
    {:ok, _} = Competitions.delete_strictly_asking(strictly_asking)

    {:noreply, stream_delete(socket, :strictly_askings, strictly_asking)}
  end
end
