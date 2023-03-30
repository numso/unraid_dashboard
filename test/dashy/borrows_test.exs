defmodule Dashy.BorrowsTest do
  use Dashy.DataCase

  alias Dashy.Borrows

  describe "borrows" do
    alias Dashy.Borrows.Borrow

    import Dashy.BorrowsFixtures

    @invalid_attrs %{name: nil, returned: nil, what: nil, when: nil}

    test "list_borrows/0 returns all borrows" do
      borrow = borrow_fixture()
      assert Borrows.list_borrows() == [borrow]
    end

    test "get_borrow!/1 returns the borrow with given id" do
      borrow = borrow_fixture()
      assert Borrows.get_borrow!(borrow.id) == borrow
    end

    test "create_borrow/1 with valid data creates a borrow" do
      valid_attrs = %{name: "some name", returned: true, what: "some what", when: ~D[2023-03-29]}

      assert {:ok, %Borrow{} = borrow} = Borrows.create_borrow(valid_attrs)
      assert borrow.name == "some name"
      assert borrow.returned == true
      assert borrow.what == "some what"
      assert borrow.when == ~D[2023-03-29]
    end

    test "create_borrow/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Borrows.create_borrow(@invalid_attrs)
    end

    test "update_borrow/2 with valid data updates the borrow" do
      borrow = borrow_fixture()
      update_attrs = %{name: "some updated name", returned: false, what: "some updated what", when: ~D[2023-03-30]}

      assert {:ok, %Borrow{} = borrow} = Borrows.update_borrow(borrow, update_attrs)
      assert borrow.name == "some updated name"
      assert borrow.returned == false
      assert borrow.what == "some updated what"
      assert borrow.when == ~D[2023-03-30]
    end

    test "update_borrow/2 with invalid data returns error changeset" do
      borrow = borrow_fixture()
      assert {:error, %Ecto.Changeset{}} = Borrows.update_borrow(borrow, @invalid_attrs)
      assert borrow == Borrows.get_borrow!(borrow.id)
    end

    test "delete_borrow/1 deletes the borrow" do
      borrow = borrow_fixture()
      assert {:ok, %Borrow{}} = Borrows.delete_borrow(borrow)
      assert_raise Ecto.NoResultsError, fn -> Borrows.get_borrow!(borrow.id) end
    end

    test "change_borrow/1 returns a borrow changeset" do
      borrow = borrow_fixture()
      assert %Ecto.Changeset{} = Borrows.change_borrow(borrow)
    end
  end
end
