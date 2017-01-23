defmodule PoShop.CartProductTest do
  use PoShop.ModelCase

  alias PoShop.CartProduct

  @valid_attrs %{amount: 5, product_id: 1, cart_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CartProduct.changeset(%CartProduct{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CartProduct.changeset(%CartProduct{}, @invalid_attrs)
    refute changeset.valid?
  end
end
