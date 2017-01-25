defmodule PoShop.CartController do
  use PoShop.Web, :controller
  alias PoShop.Repo
  alias PoShop.Cart
  alias PoShop.Product
  alias PoShop.CartProduct

  plug :find_or_create

  def index(conn, _params) do
    cart = conn.assigns.cart |> Repo.preload([cart_products: [product: :producent]])

    total_price = cart.cart_products |> Enum.reduce(0, &(&1.product.price + &2))

    render conn, "index.html", cart: cart, total_price: total_price
  end

  def create(conn, %{"product_id" => product_id}) do
    product = Repo.get!(Product, product_id)

    changeset = CartProduct.changeset(%CartProduct{}, %{"product_id" => product_id, "cart_id" => conn.assigns.cart.id, "amount" => 1})

    Repo.insert(changeset)

    conn
  end

  defp find_or_create(conn, _params) do
    case get_session(conn, :cart) do
      nil -> assign(conn, :cart, create_cart())
      cart_id -> assign(conn, :cart, Repo.get(Cart, cart_id))
    end
  end

  defp create_cart do
    %Cart{}
    |> Cart.changeset(%{})
    |> Repo.insert!()
  end
end
