defmodule WcsBot.Competitions do
  @moduledoc """
  The Competitions context.
  """

  import Ecto.Query, warn: false
  alias WcsBot.Repo

  alias WcsBot.Competitions.StrictlyAsking

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
