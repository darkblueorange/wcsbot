defmodule WcsBotWeb.DanceSchoolLive.FormComponent do
  use WcsBotWeb, :live_component

  alias WcsBot.Teachings

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage dance_school records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="dance_school-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:city]} type="text" label="City" />
        <.input field={@form[:country]} type="text" label="Country" />
        <.input field={@form[:boss]} type="text" label="Boss" />
        <.input field={@form[:website_url]} type="text" label="Website URL" />
        <.input field={@form[:mail]} type="text" label="Mail contact" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Dance school</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{dance_school: dance_school} = assigns, socket) do
    changeset = Teachings.change_dance_school(dance_school)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"dance_school" => dance_school_params}, socket) do
    changeset =
      socket.assigns.dance_school
      |> Teachings.change_dance_school(dance_school_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"dance_school" => dance_school_params}, socket) do
    save_dance_school(socket, socket.assigns.action, dance_school_params)
  end

  defp save_dance_school(socket, :edit, dance_school_params) do
    case Teachings.update_dance_school(socket.assigns.dance_school, dance_school_params) do
      {:ok, dance_school} ->
        notify_parent({:saved, dance_school})

        {:noreply,
         socket
         |> put_flash(:info, "Dance school updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_dance_school(socket, :new, dance_school_params) do
    case Teachings.create_dance_school(dance_school_params) do
      {:ok, dance_school} ->
        notify_parent({:saved, dance_school})

        {:noreply,
         socket
         |> put_flash(:info, "Dance school created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
