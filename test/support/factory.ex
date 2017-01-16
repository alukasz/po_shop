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
end
