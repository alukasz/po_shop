defmodule PoShop.ProducentTest do
  use PoShop.ModelCase

  alias PoShop.Producent

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Producent.changeset(%Producent{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Producent.changeset(%Producent{}, @invalid_attrs)
    refute changeset.valid?
  end
end
