defmodule PoShop.CategoriesControllerTest do
  use PoShop.ConnCase
  import PoShop.Factory

  test "#index lists categories", %{conn: conn} do
    parent = insert(:category)
    child = insert(:category, %{parent_id: parent.id})

    conn = get conn, category_path(conn, :index)

    assert html_response(conn, 200) =~ parent.name
    assert html_response(conn, 200) =~ child.name
  end

  test "#new has a form", %{conn: conn} do
    category = insert(:category)

    conn = get conn, category_path(conn, :new)

    assert html_response(conn, 200) =~ "Dodaj"
    assert html_response(conn, 200) =~ category.name
  end

  # can't be blank

  test "#create with valid params inserts category", %{conn: conn} do
    conn = post conn, category_path(conn, :create), %{"category" => %{"name" => "Nazwa kategorii"}}

    assert redirected_to(conn) == category_path(conn, :index)
  end

  test "#create with valid params and parent inserts category", %{conn: conn} do
    parent = insert(:category)

    conn = post conn, category_path(conn, :create), %{"category" =>
      %{"name" => "Nazwa kategorii", "parent_id" => parent.id}
    }

    assert redirected_to(conn) == category_path(conn, :index)
  end

  test "#create with invalid params rerenders form", %{conn: conn} do
    conn = post conn, category_path(conn, :create), %{"category" =>
      %{"name" => ""}
    }

    assert html_response(conn, 200) =~ "can&#39;t be blank"
  end
end
