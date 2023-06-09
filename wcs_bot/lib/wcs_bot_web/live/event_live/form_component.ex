defmodule WcsBotWeb.EventLive.FormComponent do
  use WcsBotWeb, :live_component

  alias WcsBot.Parties
  alias WcsBot.Teachings

  @impl true
  def render(assigns) do
    assigns =
      assigns
      |> assign(:dance_schools, Teachings.list_dance_schools_tuple_form())

    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage event records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="event-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:begin_date]} type="date" label="Begin date" />
        <.input field={@form[:end_date]} type="date" label="End date" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:country]} type="text" label="Country" />
        <.input field={@form[:lineup]} type="text" label="Lineup" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:url_event]} type="text" label="Url event" />
        <.input
          field={@form[:dance_school_id]}
          type="select"
          options={@dance_schools}
          prompt="Bind the event to a Dance School"
          label="Dance schools"
        />
        <.input field={@form[:wcsdc]} type="checkbox" label="Wcsdc" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Event</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{event: event} = assigns, socket) do
    changeset = Parties.change_event(event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      socket.assigns.event
      |> Parties.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    save_event(socket, socket.assigns.action, event_params)
  end

  defp save_event(socket, :edit, event_params) do
    case Parties.update_event(socket.assigns.event, event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_event(socket, :new, event_params) do
    case Parties.create_event(event_params) do
      {:ok, event} ->
        notify_parent({:saved, event})

        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
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
