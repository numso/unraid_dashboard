defmodule Dashy.BorrowsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Dashy.Borrows` context.
  """

  @doc """
  Generate a borrow.
  """
  def borrow_fixture(attrs \\ %{}) do
    {:ok, borrow} =
      attrs
      |> Enum.into(%{
        name: "some name",
        returned: true,
        what: "some what",
        when: ~D[2023-03-29]
      })
      |> Dashy.Borrows.create_borrow()

    borrow
  end
end
