defmodule DashyWeb.BorrowLiveTest do
  use DashyWeb.ConnCase

  import Phoenix.LiveViewTest
  import Dashy.BorrowsFixtures

  @create_attrs %{name: "some name", returned: true, what: "some what", when: "2023-03-29"}
  @update_attrs %{name: "some updated name", returned: false, what: "some updated what", when: "2023-03-30"}
  @invalid_attrs %{name: nil, returned: false, what: nil, when: nil}

  defp create_borrow(_) do
    borrow = borrow_fixture()
    %{borrow: borrow}
  end

  describe "Index" do
    setup [:create_borrow]

    test "lists all borrows", %{conn: conn, borrow: borrow} do
      {:ok, _index_live, html} = live(conn, ~p"/borrows")

      assert html =~ "Listing Borrows"
      assert html =~ borrow.name
    end

    test "saves new borrow", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/borrows")

      assert index_live |> element("a", "New Borrow") |> render_click() =~
               "New Borrow"

      assert_patch(index_live, ~p"/borrows/new")

      assert index_live
             |> form("#borrow-form", borrow: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#borrow-form", borrow: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/borrows")

      html = render(index_live)
      assert html =~ "Borrow created successfully"
      assert html =~ "some name"
    end

    test "updates borrow in listing", %{conn: conn, borrow: borrow} do
      {:ok, index_live, _html} = live(conn, ~p"/borrows")

      assert index_live |> element("#borrows-#{borrow.id} a", "Edit") |> render_click() =~
               "Edit Borrow"

      assert_patch(index_live, ~p"/borrows/#{borrow}/edit")

      assert index_live
             |> form("#borrow-form", borrow: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#borrow-form", borrow: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/borrows")

      html = render(index_live)
      assert html =~ "Borrow updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes borrow in listing", %{conn: conn, borrow: borrow} do
      {:ok, index_live, _html} = live(conn, ~p"/borrows")

      assert index_live |> element("#borrows-#{borrow.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#borrows-#{borrow.id}")
    end
  end

  describe "Show" do
    setup [:create_borrow]

    test "displays borrow", %{conn: conn, borrow: borrow} do
      {:ok, _show_live, html} = live(conn, ~p"/borrows/#{borrow}")

      assert html =~ "Show Borrow"
      assert html =~ borrow.name
    end

    test "updates borrow within modal", %{conn: conn, borrow: borrow} do
      {:ok, show_live, _html} = live(conn, ~p"/borrows/#{borrow}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Borrow"

      assert_patch(show_live, ~p"/borrows/#{borrow}/show/edit")

      assert show_live
             |> form("#borrow-form", borrow: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#borrow-form", borrow: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/borrows/#{borrow}")

      html = render(show_live)
      assert html =~ "Borrow updated successfully"
      assert html =~ "some updated name"
    end
  end
end
