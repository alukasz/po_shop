defmodule PoShop.CartProduct do
  use PoShop.Web, :model

  schema "carts_products" do
    field :amount, :integer

    belongs_to :cart, PoShop.Cart
    belongs_to :product, PoShop.Product
  end

  def get(product_id: product_id, cart_id: cart_id) do
    from cp in PoShop.CartProduct,
      where: cp.product_id == ^product_id,
      where: cp.cart_id == ^cart_id
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cart_id, :product_id, :amount])
    |> validate_required([:cart_id, :product_id, :amount])
    |> validate_number(:amount, greater_than_or_equal_to: 1)
  end
end
