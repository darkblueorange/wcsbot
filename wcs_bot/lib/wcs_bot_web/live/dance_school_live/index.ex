defmodule WcsBotWeb.DanceSchoolLive.Index do
  use WcsBotWeb, :live_view

  alias WcsBot.Teachings
  alias WcsBot.Teachings.DanceSchool

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :dance_schools, Teachings.list_dance_schools())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Dance school")
    |> assign(:dance_school, Teachings.get_dance_school!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Dance school")
    |> assign(:dance_school, %DanceSchool{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Dance schools")
    |> assign(:dance_school, nil)
  end

  @impl true
  def handle_info({WcsBotWeb.DanceSchoolLive.FormComponent, {:saved, dance_school}}, socket) do
    {:noreply, stream_insert(socket, :dance_schools, dance_school)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    dance_school = Teachings.get_dance_school!(id)
    {:ok, _} = Teachings.delete_dance_school(dance_school)

    {:noreply, stream_delete(socket, :dance_schools, dance_school)}
  end
end
