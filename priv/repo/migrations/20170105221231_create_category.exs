defmodule PoShop.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :parent_id, references(:categories), null: true

      timestamps()
    end

  end
end
