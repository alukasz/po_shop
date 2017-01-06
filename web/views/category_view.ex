defmodule PoShop.CategoryView do
  use PoShop.Web, :view

  def format(%PoShop.Category{parent: parent} = category) when not is_nil(parent) do
    "#{category.name}, #{category.parent.name}"
  end

  def format(%PoShop.Category{} = category) do
    category.name
  end
end
