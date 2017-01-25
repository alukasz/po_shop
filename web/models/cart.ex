defmodule PoShop.Cart do
  use PoShop.Web, :model

  schema "carts" do
    many_to_many :products, PoShop.Product, join_through: PoShop.CartProduct
    has_many :cart_products, PoShop.CartProduct

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
