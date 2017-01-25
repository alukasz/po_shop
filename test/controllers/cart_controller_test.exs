defmodule PoShop.CartControllerTest do
  use PoShop.ConnCase
  import PoShop.Factory
  alias PoShop.Cart

  @session Plug.Session.init(
   store: :cookie,
   key: "_app",
   encryption_salt: "secret",
   signing_salt: "secret"
 )

  setup do
    conn = build_conn()
    |> Plug.Session.call(@session)
    |> Plug.Conn.fetch_session()

    {:ok, conn: conn}
  end

  test "assigns a new cart if session is missing", %{conn: conn} do
    conn = get conn, cart_path(conn, :index)

    assert conn.assigns.cart
  end

  test "assigns a cart from session", %{conn: conn} do
    cart = insert(:cart)
    conn = put_session(conn, :cart, cart.id)

    conn = get conn, cart_path(conn, :index)

    assert conn.assigns.cart.id == cart.id
  end

  test "#index renders products from cart", %{conn: conn} do
    cart = build(:cart) |> with_products(2) |> insert
    conn = put_session(conn, :cart, cart.id)

    conn = get conn, cart_path(conn, :index)

    total_price = cart.products |> Enum.reduce(0.0, &(&1.price + &2))
    for product <- cart.products do
      assert html_response(conn, 200) =~ product.name
    end

    assert html_response(conn, 200) =~ to_string(total_price)
  end

  test "#index renders message with empty cart", %{conn: conn} do
    cart = insert(:cart)

    conn = get conn, cart_path(conn, :index)

    assert html_response(conn, 200) =~ "Brak produtków w koszyku."
  end

  test "#create adds product to the cart", %{conn: conn} do
    product = insert(:product)

    conn = post conn, cart_path(conn, :create, %{product_id: product.id})

    cart = Repo.preload(conn.assigns.cart, cart_products: :product)

    assert product.id in (cart.cart_products |> Enum.map(&(&1.product.id)))
  end
end
