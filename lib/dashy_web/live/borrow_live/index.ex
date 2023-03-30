defmodule DashyWeb.BorrowLive.Index do
  use DashyWeb, :live_view

  alias Dashy.Borrows
  alias Dashy.Borrows.Borrow

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :borrows, Borrows.list_borrows())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Borrow")
    |> assign(:borrow, Borrows.get_borrow!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Borrow")
    |> assign(:borrow, %Borrow{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Borrows")
    |> assign(:borrow, nil)
  end

  @impl true
  def handle_info({DashyWeb.BorrowLive.FormComponent, {:saved, borrow}}, socket) do
    {:noreply, stream_insert(socket, :borrows, borrow)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    borrow = Borrows.get_borrow!(id)
    {:ok, _} = Borrows.delete_borrow(borrow)

    {:noreply, stream_delete(socket, :borrows, borrow)}
  end
end
