defmodule PoShop.Cart do
  use PoShop.Web, :model
  alias PoShop.Product
  alias PoShop.CartProduct

  schema "carts" do
    many_to_many :products, Product, join_through: CartProduct

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
