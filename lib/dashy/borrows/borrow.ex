defmodule Dashy.Borrows.Borrow do
  use Ecto.Schema
  import Ecto.Changeset

  schema "borrows" do
    field :name, :string
    field :returned, :boolean, default: false
    field :what, :string
    field :when, :date

    timestamps()
  end

  @doc false
  def changeset(borrow, attrs) do
    borrow
    |> cast(attrs, [:name, :what, :when, :returned])
    |> validate_required([:name, :what, :when, :returned])
  end
end
