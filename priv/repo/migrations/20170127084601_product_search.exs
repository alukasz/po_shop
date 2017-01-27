defmodule PoShop.Repo.Migrations.ProductSearch do
  use Ecto.Migration

  def up do
    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX product_name_trgm_index ON products USING gin (name gin_trgm_ops);"
  end

  def down do
    execute "DROP INDEX product_name_trgm_index;"
  end
end
