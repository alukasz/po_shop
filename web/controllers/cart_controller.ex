defmodule PoShop.CartController do
  use PoShop.Web, :controller
  alias PoShop.Repo
  alias PoShop.Cart

  plug :find_or_create

  def index(conn, _params) do
    render conn, "index.html"
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
