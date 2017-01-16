defmodule PoShop.ProductController do
  use PoShop.Web, :controller
  alias PoShop.Repo
  alias PoShop.Category
  alias PoShop.Producent
  alias PoShop.Product

  plug :find_category when action in [:index, :show]
  plug :find_producent when action in [:index, :show]

  plug :scrub_params, "product" when action in [:create]

  def index(conn, params) do
    products = products_with_descendants(conn,
      Map.get(params, "sort", nil),
      Map.get(params, "producent", nil)
    )
    render conn, "index.html", products: products, breadcrumbs: breadcrumbs(conn),
      categories: categories(conn), producents: producents(conn)
  end

  def new(conn, _params) do
    categories = Category |> Repo.all
    producents = Producent |> Repo.all
    changeset = Product.changeset(%Product{})

    render conn, "new.html", categories: categories, producents: producents,
      changeset: changeset
  end

  def create(conn, %{"product" => params}) do
    changeset = Product.changeset(%Product{}, params)

    case Repo.insert(changeset) do
      {:ok, product} ->
        conn
        |> put_flash("success", "Produkt został dodany")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        categories = Category |> Repo.all
        producents = Producent |> Repo.all
        conn
        |> render("new.html", categories: categories, producents: producents,
          changeset: changeset)
    end
  end

  def show(conn, params) do
    product = Product
    |> Repo.get(1)
    |> Repo.preload(:producent)
    # |> Repo.preload(:category)

    render conn, "show.html", product: product, breadcrumbs: breadcrumbs(conn) ++ [product]
  end

  defp find_category(conn, _params) do
    assign(conn, :category, Repo.get!(Category, conn.params["category_id"]))
  end

  defp find_producent(conn, _params) do
    case conn.params["producent"] do
      "" -> assign(conn, :producent, %Producent{})
      id when is_binary(id) -> assign(conn, :producent, Repo.get!(Producent, id))
      _ -> assign(conn, :producent, %Producent{})
    end

  end

  defp category(conn), do: conn.assigns.category

  defp products_with_descentants(conn, order_by) do
    category_descendants = category(conn)
    |> Category.descendants
    |> Repo.all

    Product
    |> Product.preload
    |> Product.category([category(conn) | category_descendants])
    |> Product.order_by(order_by)
  end

  defp products_with_descendants(conn, order_by, nil) do
    products_with_descentants(conn, order_by)
    |> Repo.all
  end

  defp products_with_descendants(conn, order_by, producent) do
    products_with_descentants(conn, order_by)
    |> Product.producent(producent)
    |> Repo.all
  end

  defp breadcrumbs(conn) do
    breadcrumbs = category(conn)
    |> Category.ancestors
    |> Repo.all
    breadcrumbs ++ [category(conn)]
  end

  defp categories(conn) do
    categories = category(conn)
    |> Category.siblings
    |> Repo.all
    categories ++ [category(conn)]
    |> Enum.sort_by(&(&1.name))
  end

  def producents(conn) do
    category_descendants = category(conn)
    |> Category.descendants
    |> Repo.all

    Producent
    |> Producent.for_category([category(conn) | category_descendants])
    |> Ecto.Query.limit(10)
    |> Repo.all
  end
end
