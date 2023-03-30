defmodule Dashy.Borrows do
  @moduledoc """
  The Borrows context.
  """

  import Ecto.Query, warn: false
  alias Dashy.Repo

  alias Dashy.Borrows.Borrow

  @doc """
  Returns the list of borrows.

  ## Examples

      iex> list_borrows()
      [%Borrow{}, ...]

  """
  def list_borrows do
    Repo.all(Borrow)
  end

  @doc """
  Gets a single borrow.

  Raises `Ecto.NoResultsError` if the Borrow does not exist.

  ## Examples

      iex> get_borrow!(123)
      %Borrow{}

      iex> get_borrow!(456)
      ** (Ecto.NoResultsError)

  """
  def get_borrow!(id), do: Repo.get!(Borrow, id)

  @doc """
  Creates a borrow.

  ## Examples

      iex> create_borrow(%{field: value})
      {:ok, %Borrow{}}

      iex> create_borrow(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_borrow(attrs \\ %{}) do
    %Borrow{}
    |> Borrow.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a borrow.

  ## Examples

      iex> update_borrow(borrow, %{field: new_value})
      {:ok, %Borrow{}}

      iex> update_borrow(borrow, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_borrow(%Borrow{} = borrow, attrs) do
    borrow
    |> Borrow.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a borrow.

  ## Examples

      iex> delete_borrow(borrow)
      {:ok, %Borrow{}}

      iex> delete_borrow(borrow)
      {:error, %Ecto.Changeset{}}

  """
  def delete_borrow(%Borrow{} = borrow) do
    Repo.delete(borrow)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking borrow changes.

  ## Examples

      iex> change_borrow(borrow)
      %Ecto.Changeset{data: %Borrow{}}

  """
  def change_borrow(%Borrow{} = borrow, attrs \\ %{}) do
    Borrow.changeset(borrow, attrs)
  end
end
