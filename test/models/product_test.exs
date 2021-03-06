defmodule PoShop.ProductTest do
  use PoShop.ModelCase

  alias PoShop.Product

  @valid_attrs %{description: "some content", name: "some content", price: "120.5", stock: 42, producent_id: 1, category_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end
end
