defmodule PoShop.ProductControllerTest do
  use PoShop.ConnCase
  import PoShop.Factory

  test "#new shows form", %{conn: conn} do
    conn = get conn, product_path(conn, :new)

    assert html_response(conn, 200) =~ "Nowy produkt"
  end

  @tag :pending
  test "#create with valid params inserts product", %{conn: conn} do
    params = params_with_assocs(:product, %{price: "2.99"})

    conn = post conn, product_path(conn, :create, %{"product" => params})

    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "#create with invalid params rerenders form", %{conn: conn} do
    conn = post conn, product_path(conn, :create, %{"product" => %{"name" => ""}})

    assert html_response(conn, 200) =~ Phoenix.HTML.Safe.to_iodata("can't be blank")
  end

  test "#index show products", %{conn: conn} do
    product = insert(:product)

    conn = get conn, category_product_path(conn, :index, product.category)

    assert html_response(conn, 200) =~ product.name
    assert html_response(conn, 200) =~ product.producent.name
  end

  test "#index with root category shows all products", %{conn: conn} do
    root_category = insert(:category)
    child_category = insert(:category, parent: root_category)

    product_root = insert(:product, category: root_category)
    product_child = insert(:product, category: child_category)

    conn = get conn, category_product_path(conn, :index, root_category)

    assert html_response(conn, 200) =~ product_root.name
    assert html_response(conn, 200) =~ product_child.name
  end

  test "#index with child category shows only child category products", %{conn: conn} do
    root_category = insert(:category)
    child_category = insert(:category, parent: root_category)

    product_root = insert(:product, category: root_category)
    product_child = insert(:product, category: child_category)

    conn = get conn, category_product_path(conn, :index, child_category)

    refute html_response(conn, 200) =~ product_root.name
    assert html_response(conn, 200) =~ product_child.name
  end

  test "#index with child category show child category", %{conn: conn} do
    root_category = insert(:category)
    child_category = insert(:category, parent: root_category)

    conn = get conn, category_product_path(conn, :index, root_category)

    assert html_response(conn, 200) =~ root_category.name
    assert html_response(conn, 200) =~ child_category.name
  end

  test "#index with child category show sibling category", %{conn: conn} do
    root_category = insert(:category)
    child_category = insert(:category, parent: root_category)
    sibling_category = insert(:category, parent: root_category)

    conn = get conn, category_product_path(conn, :index, child_category)

    assert html_response(conn, 200) =~ child_category.name
    assert html_response(conn, 200) =~ sibling_category.name
  end

  test "#index with child category does not show parent category", %{conn: conn} do
    root_category = insert(:category)
    child_category = insert(:category, parent: root_category)

    conn = get conn, category_product_path(conn, :index, child_category)

    assert html_response(conn, 200) =~ child_category.name
    refute html_response(conn, 200) =~ "<div class='menu-list'>/.*#{root_category.name}.*/</div>/"
  end

  test "#index can filter products by producent", %{conn: conn} do
    category = insert(:category)
    producent_visible = insert(:producent)
    producent_hidden = insert(:producent)
    product_visible = insert(:product, %{producent: producent_visible, category: category})
    product_hidden = insert(:product, %{producent: producent_hidden, category: category})

    conn = get conn, category_product_path(conn, :index, category, %{producent: producent_visible.id})

    assert html_response(conn, 200) =~ product_visible.name
    refute html_response(conn, 200) =~ product_hidden.name
  end

  test "#show shows product", %{conn: conn} do
    category = insert(:category)
    product = insert(:product, category: category)

    conn = get conn, category_product_path(conn, :show, category.id, product.id)

    assert html_response(conn, 200) =~ product.name
    assert html_response(conn, 200) =~ to_string(product.price)
  end
end
