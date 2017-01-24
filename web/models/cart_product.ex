defmodule PoShop.CartProduct do
  use PoShop.Web, :model
  alias PoShop.Product
  alias PoShop.Cart

  schema "carts_products" do
    field :amount, :integer

    belongs_to :cart, Cart
    belongs_to :product, Product
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
