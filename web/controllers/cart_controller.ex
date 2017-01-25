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
    total_amount = cart.cart_products |> Enum.reduce(0, &(&1.amount + &2))

    render conn, "index.html", cart: cart, total_price: total_price, total_amount: total_amount
  end

  def create(conn, %{"product_id" => product_id, "amount" => amount}) do
    product = Repo.get!(Product, product_id)

    case CartProduct.get(product_id: product.id, cart_id: conn.assigns.cart.id) |> Repo.one do
      nil ->
        CartProduct.changeset(%CartProduct{}, %{"product_id" => product.id, "cart_id" => conn.assigns.cart.id, "amount" => amount})
        |> Repo.insert()
      cart_product ->
        CartProduct.changeset(cart_product, %{"amount" => 1})
        |> Repo.update()
    end

    IO.inspect NavigationHistory.last_path(conn)

    redirect conn, to: NavigationHistory.last_path(conn, default:  "/") <> "?dialog=show"
  end

  def update(conn, %{"product_id" => product_id, "amount" => amount}) do
    product = Repo.get!(Product, product_id)
    cart_product = CartProduct.get(product_id: product.id, cart_id: conn.assigns.cart.id) |> Repo.one!

    changeset = CartProduct.changeset(cart_product, %{"amount" => amount})
    Repo.update(changeset)

    redirect conn, to: NavigationHistory.last_path(conn, default:  "/")
  end

  def delete(conn, %{"product_id" => product_id}) do
    product = Repo.get!(Product, product_id)
    CartProduct.get(product_id: product.id, cart_id: conn.assigns.cart.id) |> Repo.one! |> Repo.delete!

    redirect conn, to: cart_path(conn, :index)
  end

  defp find_or_create(conn, _params) do
    case get_session(conn, :cart) do
      nil ->
        cart = create_cart()
        conn
        |> assign(:cart, cart)
        |> put_session(:cart, cart.id)
      cart_id ->
        assign(conn, :cart, Repo.get(Cart, cart_id))
    end
  end

  defp create_cart do
    %Cart{}
    |> Cart.changeset(%{})
    |> Repo.insert!()
  end
end
