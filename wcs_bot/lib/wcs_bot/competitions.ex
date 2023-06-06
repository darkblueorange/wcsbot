defmodule WcsBot.Competitions do
  @moduledoc """
  The Competitions context.
  """

  import Ecto.Query, warn: false
  alias WcsBot.Repo

  alias WcsBot.Competitions.StrictlyAsking

  # allow us to query dynamically in a where clause any DB column and its value (country: country_value, or city: city_value)
  defp query_insert_any(field_name, field_value) do
    field_value
    |> if do
      dynamic([sa], field(sa, ^field_name) == ^field_value)
    else
      true
    end
  end

  defp query_insert_timeframe(field_name, timeframe_value) do
    timeframe_value
    |> case do
      "week" ->
        dynamic(
          [sa, ev],
          fragment(
            "CURRENT_DATE <= ? AND ? <= (CURRENT_DATE + INTERVAL '1 week')",
            field(ev, ^field_name),
            field(ev, ^field_name)
          )
        )

      "month" ->
        dynamic(
          [sa, ev],
          fragment(
            "CURRENT_DATE <= ? AND ? <= (CURRENT_DATE + INTERVAL '1 month')",
            field(ev, ^field_name),
            field(ev, ^field_name)
          )
        )

      "year" ->
        dynamic(
          [sa, ev],
          fragment(
            "CURRENT_DATE <= ? AND ? <= (CURRENT_DATE + INTERVAL '1 year')",
            field(ev, ^field_name),
            field(ev, ^field_name)
          )
        )

      _ ->
        true
    end
  end

  @doc """
  Returns the list of strictly_askings.

  ## Examples

      iex> list_strictly_askings()
      [%StrictlyAsking{}, ...]

  """
  def list_strictly_askings do
    Repo.all(StrictlyAsking)
  end

  def list_strictly_askings_with_preload do
    StrictlyAsking
    |> Repo.all()
    |> Repo.preload(:event)
  end

  alias WcsBot.Parties.Event

  def list_strictly_askings_by(%{timeframe: timeframe, event_id: event_id}) do
    interval_lookup = :begin_date |> query_insert_timeframe(timeframe)
    event_id_lookup = :event_id |> query_insert_any(event_id)

    StrictlyAsking
    |> join(:left, [sa], ev in Event, on: sa.event_id == ev.id)
    |> where([sa], ^interval_lookup)
    |> where([sa], ^event_id_lookup)
    |> Repo.all()
    |> Repo.preload(:event)
  end

  @doc """
  Gets a single strictly_asking.

  Raises `Ecto.NoResultsError` if the Strictly asking does not exist.

  ## Examples

      iex> get_strictly_asking!(123)
      %StrictlyAsking{}

      iex> get_strictly_asking!(456)
      ** (Ecto.NoResultsError)

  """
  def get_strictly_asking!(id), do: Repo.get!(StrictlyAsking, id)

  def get_strictly_asking_with_preload!(id),
    do: Repo.get!(StrictlyAsking, id) |> Repo.preload(:event)

  @doc """
  Creates a strictly_asking.

  ## Examples

      iex> create_strictly_asking(%{field: value})
      {:ok, %StrictlyAsking{}}

      iex> create_strictly_asking(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_strictly_asking(attrs \\ %{}) do
    %StrictlyAsking{}
    |> StrictlyAsking.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a strictly_asking.

  ## Examples

      iex> update_strictly_asking(strictly_asking, %{field: new_value})
      {:ok, %StrictlyAsking{}}

      iex> update_strictly_asking(strictly_asking, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_strictly_asking(%StrictlyAsking{} = strictly_asking, attrs) do
    strictly_asking
    |> StrictlyAsking.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a strictly_asking.

  ## Examples

      iex> delete_strictly_asking(strictly_asking)
      {:ok, %StrictlyAsking{}}

      iex> delete_strictly_asking(strictly_asking)
      {:error, %Ecto.Changeset{}}

  """
  def delete_strictly_asking(%StrictlyAsking{} = strictly_asking) do
    Repo.delete(strictly_asking)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking strictly_asking changes.

  ## Examples

      iex> change_strictly_asking(strictly_asking)
      %Ecto.Changeset{data: %StrictlyAsking{}}

  """
  def change_strictly_asking(%StrictlyAsking{} = strictly_asking, attrs \\ %{}) do
    StrictlyAsking.changeset(strictly_asking, attrs)
  end
end
