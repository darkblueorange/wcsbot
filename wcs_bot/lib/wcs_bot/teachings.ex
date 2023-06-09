defmodule WcsBot.Teachings do
  @moduledoc """
  The Teachings context.
  """

  import Ecto.Query, warn: false
  alias WcsBot.Repo

  alias WcsBot.Teachings.DanceSchool

  # allow us to query dynamically in a where clause any DB column and its value (country: country_value, or city: city_value)
  defp query_insert_any(field_name, field_value) do
    field_value
    |> if do
      dynamic([sp], field(sp, ^field_name) == ^field_value)
    else
      true
    end
  end

  @doc """
  Returns the list of dance_schools.

  ## Examples

      iex> list_dance_schools()
      [%DanceSchool{}, ...]

  """
  def list_dance_schools do
    Repo.all(DanceSchool)
  end

  def list_dance_schools_by(%{country: country, city: city}) do
    country_lookup = :country |> query_insert_any(country)
    city_lookup = :city |> query_insert_any(city)

    DanceSchool
    |> where([sp], ^country_lookup)
    |> where([sp], ^city_lookup)
    |> Repo.all()
  end

  def list_dance_schools_tuple_form do
    DanceSchool
    |> select([dc], {dc.name, dc.id})
    |> Repo.all()
  end

  @doc """
  Gets a single dance_school.

  Raises `Ecto.NoResultsError` if the Dance school does not exist.

  ## Examples

      iex> get_dance_school!(123)
      %DanceSchool{}

      iex> get_dance_school!(456)
      ** (Ecto.NoResultsError)

  """
  def get_dance_school!(id), do: Repo.get!(DanceSchool, id)

  @doc """
  Creates a dance_school.

  ## Examples

      iex> create_dance_school(%{field: value})
      {:ok, %DanceSchool{}}

      iex> create_dance_school(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_dance_school(attrs \\ %{}) do
    %DanceSchool{}
    |> DanceSchool.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a dance_school.

  ## Examples

      iex> update_dance_school(dance_school, %{field: new_value})
      {:ok, %DanceSchool{}}

      iex> update_dance_school(dance_school, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_dance_school(%DanceSchool{} = dance_school, attrs) do
    dance_school
    |> DanceSchool.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a dance_school.

  ## Examples

      iex> delete_dance_school(dance_school)
      {:ok, %DanceSchool{}}

      iex> delete_dance_school(dance_school)
      {:error, %Ecto.Changeset{}}

  """
  def delete_dance_school(%DanceSchool{} = dance_school) do
    Repo.delete(dance_school)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking dance_school changes.

  ## Examples

      iex> change_dance_school(dance_school)
      %Ecto.Changeset{data: %DanceSchool{}}

  """
  def change_dance_school(%DanceSchool{} = dance_school, attrs \\ %{}) do
    DanceSchool.changeset(dance_school, attrs)
  end
end
