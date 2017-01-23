defmodule PoShop.Repo.Migrations.CreateCartProduct do
  use Ecto.Migration

  def change do
    create table(:carts_products) do
      add :amount, :integer

      add :cart_id, references(:carts)
      add :product_id, references(:products)
    end
  end
end
