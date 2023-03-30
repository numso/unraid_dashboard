defmodule DashyWeb.BorrowLive.Show do
  use DashyWeb, :live_view

  alias Dashy.Borrows

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:borrow, Borrows.get_borrow!(id))}
  end

  defp page_title(:show), do: "Show Borrow"
  defp page_title(:edit), do: "Edit Borrow"
end
