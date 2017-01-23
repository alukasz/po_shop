defmodule PoShop.CartTest do
  use PoShop.ModelCase

  alias PoShop.Cart

  @valid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Cart.changeset(%Cart{}, @valid_attrs)
    assert changeset.valid?
  end
end
