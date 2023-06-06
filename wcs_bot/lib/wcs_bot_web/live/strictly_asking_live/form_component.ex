defmodule WcsBotWeb.StrictlyAskingLive.FormComponent do
  use WcsBotWeb, :live_component

  alias WcsBot.Competitions
  alias WcsBot.Parties

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:events, Parties.list_events_tuple_form())

    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage strictly_asking records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="strictly_asking-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:wcsdc_level]} type="text" label="Wcsdc level" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:asking_filled]} type="checkbox" label="Asking filled" />
        <.input field={@form[:dancing_role]} type="text" label="Dancing role" />
        <.input field={@form[:discord_tag]} type="text" label="Discord tag" />
        <.input
          field={@form[:event_id]}
          type="select"
          options={@events}
          prompt="Bind the strictly asking to an Event"
          label="Events"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Strictly asking</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{strictly_asking: strictly_asking} = assigns, socket) do
    changeset = Competitions.change_strictly_asking(strictly_asking)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"strictly_asking" => strictly_asking_params}, socket) do
    changeset =
      socket.assigns.strictly_asking
      |> Competitions.change_strictly_asking(strictly_asking_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"strictly_asking" => strictly_asking_params}, socket) do
    save_strictly_asking(socket, socket.assigns.action, strictly_asking_params)
  end

  defp save_strictly_asking(socket, :edit, strictly_asking_params) do
    case Competitions.update_strictly_asking(
           socket.assigns.strictly_asking,
           strictly_asking_params
         ) do
      {:ok, strictly_asking} ->
        notify_parent({:saved, strictly_asking})

        {:noreply,
         socket
         |> put_flash(:info, "Strictly asking updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_strictly_asking(socket, :new, strictly_asking_params) do
    case Competitions.create_strictly_asking(strictly_asking_params) do
      {:ok, strictly_asking} ->
        notify_parent({:saved, strictly_asking})

        {:noreply,
         socket
         |> put_flash(:info, "Strictly asking created successfully")
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
