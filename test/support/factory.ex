defmodule PoShop.Factory do
  use ExMachina.Ecto, repo: PoShop.Repo
  
  def category_factory do
    %PoShop.Category{
      name: sequence(:category_name, &"Category-#{&1}")
    }
  end
end
