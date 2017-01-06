defmodule PoShop.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :text
      add :price, :float
      add :stock, :integer
      add :producent_id, references(:producents, on_delete: :nothing)
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end
    create index(:products, [:producent_id])
    create index(:products, [:category_id])

  end
end
