defmodule WcsBotWeb.SmallPartyLive.FormComponent do
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
        <:subtitle>Use this form to manage small_party records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="small_party-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:date]} type="date" label="Date" />
        <.input field={@form[:begin_hour]} type="datetime-local" label="Begin hour" />
        <.input field={@form[:end_hour]} type="datetime-local" label="End hour" />
        <.input field={@form[:address]} type="text" label="Address" />
        <.input field={@form[:country]} type="text" label="Country" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:url_party]} type="text" label="Url party" />
        <.input field={@form[:fb_link]} type="text" label="Fb link" />
        <.input field={@form[:dj]} type="text" label="Dj" />
        <.input
          field={@form[:dance_school_id]}
          type="select"
          options={@dance_schools}
          prompt="Bind the event to a Dance School"
          label="Dance schools"
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Small party</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{small_party: small_party} = assigns, socket) do
    changeset = Parties.change_small_party(small_party)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"small_party" => small_party_params}, socket) do
    changeset =
      socket.assigns.small_party
      |> Parties.change_small_party(small_party_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"small_party" => small_party_params}, socket) do
    save_small_party(socket, socket.assigns.action, small_party_params)
  end

  defp save_small_party(socket, :edit, small_party_params) do
    case Parties.update_small_party(socket.assigns.small_party, small_party_params) do
      {:ok, small_party} ->
        notify_parent({:saved, small_party})

        {:noreply,
         socket
         |> put_flash(:info, "Small party updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_small_party(socket, :new, small_party_params) do
    case Parties.create_small_party(small_party_params) do
      {:ok, small_party} ->
        notify_parent({:saved, small_party})

        {:noreply,
         socket
         |> put_flash(:info, "Small party created successfully")
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
