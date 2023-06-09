defmodule WcsBot.Parties do
  @moduledoc """
  The Parties context.
  """

  import Ecto.Query, warn: false
  alias WcsBot.Repo

  alias WcsBot.Parties.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
  end

  def list_future_events do
    Event
    |> where([ev], fragment(" ? > CURRENT_DATE", ev.end_date))
    |> Repo.all()
  end

  def list_events_by(%{timeframe: timeframe, country: country, city: city}) do
    interval_lookup = :begin_date |> query_insert_timeframe(timeframe)
    country_lookup = :country |> query_insert_any(country)
    city_lookup = :city |> query_insert_any(city)

    Event
    |> where([sp], ^interval_lookup)
    |> where([sp], ^country_lookup)
    |> where([sp], ^city_lookup)
    |> Repo.all()
  end

  def list_events_with_preload do
    Event
    |> Repo.all()
    |> Repo.preload([:dance_school])
  end

  def list_events_tuple_form do
    Event
    |> select([ev], {ev.name, ev.id})
    |> Repo.all()
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id), do: Repo.get!(Event, id)

  def get_event_with_preload!(id), do: Repo.get!(Event, id) |> Repo.preload(:dance_school)

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  alias WcsBot.Parties.SmallParty

  @doc """
  Returns the list of small_parties.

  ## Examples

      iex> list_small_parties()
      [%SmallParty{}, ...]

  """
  def list_small_parties do
    Repo.all(SmallParty)
  end

  def list_small_parties_with_preload do
    SmallParty
    |> Repo.all()
    |> Repo.preload(:dance_school)
  end

  @doc """
  timeframe = week, month, year
  """
  def list_small_parties_by(%{timeframe: timeframe, country: country, city: city}) do
    interval_lookup = :party_date |> query_insert_timeframe(timeframe)
    country_lookup = :country |> query_insert_any(country)
    city_lookup = :city |> query_insert_any(city)

    SmallParty
    |> where([sp], ^interval_lookup)
    |> where([sp], ^country_lookup)
    |> where([sp], ^city_lookup)
    |> Repo.all()
  end

  # allow us to query dynamically in a where clause any DB column and its value (country: country_value, or city: city_value)
  defp query_insert_any(field_name, field_value) do
    field_value
    |> if do
      dynamic([sp], field(sp, ^field_name) == ^field_value)
    else
      true
    end
  end

  defp query_insert_timeframe(field_name, timeframe_value) do
    timeframe_value
    |> case do
      "week" ->
        dynamic(
          [sp],
          fragment(
            "CURRENT_DATE <= ? AND ? <= (CURRENT_DATE + INTERVAL '1 week')",
            field(sp, ^field_name),
            field(sp, ^field_name)
          )
        )

      "month" ->
        dynamic(
          [sp],
          fragment(
            "CURRENT_DATE <= ? AND ? <= (CURRENT_DATE + INTERVAL '1 month')",
            field(sp, ^field_name),
            field(sp, ^field_name)
          )
        )

      "year" ->
        dynamic(
          [sp],
          fragment(
            "CURRENT_DATE <= ? AND ? <= (CURRENT_DATE + INTERVAL '1 year')",
            field(sp, ^field_name),
            field(sp, ^field_name)
          )
        )

      _ ->
        true
    end
  end

  @doc """
  Gets a single small_party.

  Raises `Ecto.NoResultsError` if the Small party does not exist.

  ## Examples

      iex> get_small_party!(123)
      %SmallParty{}

      iex> get_small_party!(456)
      ** (Ecto.NoResultsError)

  """
  def get_small_party!(id), do: Repo.get!(SmallParty, id)

  def get_small_party_with_preload!(id),
    do:
      Repo.get!(SmallParty, id)
      |> Repo.preload(:dance_school)

  @doc """
  Creates a small_party.

  ## Examples

      iex> create_small_party(%{field: value})
      {:ok, %SmallParty{}}

      iex> create_small_party(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_small_party(attrs \\ %{}) do
    %SmallParty{}
    |> SmallParty.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a small_party.

  ## Examples

      iex> update_small_party(small_party, %{field: new_value})
      {:ok, %SmallParty{}}

      iex> update_small_party(small_party, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_small_party(%SmallParty{} = small_party, attrs) do
    small_party
    |> SmallParty.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a small_party.

  ## Examples

      iex> delete_small_party(small_party)
      {:ok, %SmallParty{}}

      iex> delete_small_party(small_party)
      {:error, %Ecto.Changeset{}}

  """
  def delete_small_party(%SmallParty{} = small_party) do
    Repo.delete(small_party)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking small_party changes.

  ## Examples

      iex> change_small_party(small_party)
      %Ecto.Changeset{data: %SmallParty{}}

  """
  def change_small_party(%SmallParty{} = small_party, attrs \\ %{}) do
    SmallParty.changeset(small_party, attrs)
  end
end
