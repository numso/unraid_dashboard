defmodule DashyWeb.BorrowLive.FormComponent do
  use DashyWeb, :live_component

  alias Dashy.Borrows

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage borrow records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="borrow-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:what]} type="text" label="What" />
        <.input field={@form[:when]} type="date" label="When" />
        <.input field={@form[:returned]} type="checkbox" label="Returned" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Borrow</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{borrow: borrow} = assigns, socket) do
    changeset = Borrows.change_borrow(borrow)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"borrow" => borrow_params}, socket) do
    changeset =
      socket.assigns.borrow
      |> Borrows.change_borrow(borrow_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"borrow" => borrow_params}, socket) do
    save_borrow(socket, socket.assigns.action, borrow_params)
  end

  defp save_borrow(socket, :edit, borrow_params) do
    case Borrows.update_borrow(socket.assigns.borrow, borrow_params) do
      {:ok, borrow} ->
        notify_parent({:saved, borrow})

        {:noreply,
         socket
         |> put_flash(:info, "Borrow updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_borrow(socket, :new, borrow_params) do
    case Borrows.create_borrow(borrow_params) do
      {:ok, borrow} ->
        notify_parent({:saved, borrow})

        {:noreply,
         socket
         |> put_flash(:info, "Borrow created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
