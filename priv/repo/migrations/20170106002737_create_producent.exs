defmodule PoShop.Repo.Migrations.CreateProducent do
  use Ecto.Migration

  def change do
    create table(:producents) do
      add :name, :string

      timestamps()
    end

  end
end
