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

    assert conn.assigns[:cart]
  end

  test "assigns a cart from session", %{conn: conn} do
    cart = insert(:cart)

    conn = fetch_session(conn)

    conn = put_session(conn, :cart, cart.id)
    conn = get conn, cart_path(conn, :index)

    assert conn.assigns[:cart] == cart
  end
end
