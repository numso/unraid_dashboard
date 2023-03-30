defmodule Dashy.Repo.Migrations.CreateBorrows do
  use Ecto.Migration

  def change do
    create table(:borrows) do
      add :name, :string
      add :what, :string
      add :when, :date
      add :returned, :boolean, default: false, null: false

      timestamps()
    end
  end
end
