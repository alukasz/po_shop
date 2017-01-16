defmodule PoShop.ProductViewTest do
  use PoShop.ConnCase
  import PoShop.Factory
  alias PoShop.ProductView

  test "breadcrumbs/2 renders breadcrumbs from list of categories" do
      categories = insert_pair(:category)

      html = ProductView.breadcrumbs(build_conn(), categories)

      assert in_html(Enum.at(categories, 0).name, html)
      assert in_html(Enum.at(categories, 1).name, html)
      assert in_html("span", html)
  end

  test "breadcrumbs/2 with 1 category don't render delimeters" do
    category = insert(:category)

    html = ProductView.breadcrumbs(build_conn(), [category])

    refute in_html("span", html)
  end

  test "same/2 with identical objects returns 'is-active'" do
    category = insert(:category)

    assert ProductView.same(category, category) == "is-active"
  end

  test "same/2 with different objects returns empty string" do
    category_one = insert(:category)
    category_two = insert(:category)

    assert ProductView.same(category_one, category_two) == ""
  end

  test "same/2 object must be the same struct" do
    object_one = insert(:category)
    object_two = insert(:producent)

    object_one = Map.put(object_one, :id, object_two.id)

    assert object_one.id == object_two.id
    assert ProductView.same(object_one, object_two) == ""
  end

  defp in_html(needle, list_of_safe) do
    safe = Keyword.get_values(list_of_safe, :safe) |> List.flatten
    needle in safe
  end
end
