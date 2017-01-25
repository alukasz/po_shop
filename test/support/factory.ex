defmodule PoShop.Factory do
  use ExMachina.Ecto, repo: PoShop.Repo

  def category_factory do
    %PoShop.Category{
      name: sequence(:category_name, &"Category-#{&1}")
    }
  end

  def producent_factory do
    %PoShop.Producent{
      name: sequence(:category_name, &"Producent-#{&1}")
    }
  end

  def product_factory do
    %PoShop.Product{
      name: sequence(:product_name, &"Product-#{&1}"),
      description: "Lorem ipsum",
      price: 2.99,
      stock: 10,
      category: build(:category),
      producent: build(:producent)
    }
  end

  def cart_factory do
    %PoShop.Cart{}
  end

  def cart_product_factory do
    %PoShop.CartProduct{
      amount: 1,
      product: build(:product)
    }
  end

  def with_products(cart, number \\ 1) do
    %{cart | cart_products: build_list(number, :cart_product)}
  end
end
