defmodule PoShop.ProductController do
  use PoShop.Web, :controller
  alias PoShop.Repo
  alias PoShop.Category
  alias PoShop.Producent
  alias PoShop.Product

  plug :find_category when action in [:index, :show]
  plug :find_producent when action in [:index, :show]

  plug :scrub_params, "product" when action in [:create]

  @doc """
  Renders all products for given category.
  """
  def index(conn, params) do
    products = current_products(conn,
      Map.get(params, "sort", "name"),
      Map.get(params, "producent", nil)
    )
    render conn, "index.html", products: products, breadcrumbs: breadcrumbs(conn),
      categories: get_categories(conn), producents: producents(conn)
  end

  @doc """
  Renders form for creating a new product.
  """
  def new(conn, _params) do
    categories = Category |> Repo.all
    producents = Producent |> Repo.all
    changeset = Product.changeset(%Product{})

    render conn, "new.html", categories: categories, producents: producents,
      changeset: changeset
  end

  @doc """
  Inserts product in the database. If product params are invalid, rerenders form
  """
  def create(conn, %{"product" => params}) do
    changeset = Product.changeset(%Product{}, params)

    case Repo.insert(changeset) do
      {:ok, _product} ->
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

  @doc """
  Renders product page.
  """
  def show(conn, params) do
    product = Product
    |> Repo.get(params["id"])
    |> Repo.preload(:producent)
    |> Repo.preload(:category)

    render conn, "show.html", product: product, breadcrumbs: breadcrumbs(conn, product.category) ++ [product]
  end

  def search(conn, %{"q" => search_term}) do
    root_category = Category |> Repo.get(1)
    conn = assign(conn, :category, root_category)
    products = Product
    |> Product.search(search_term)
    |> Repo.all
    |> Repo.preload(:producent)
    |> Repo.preload(:category)

    render conn, "index.html", products: products, breadcrumbs: [root_category], categories: [], producents: []
  end

  @doc """
  Assigns category from params
  """
  defp find_category(conn, _params) do
    assign(conn, :category, Repo.get!(Category, conn.params["category_id"]))
  end

  @doc """
  Assigns producent from params
  """
  defp find_producent(conn, _params) do
    case conn.params["producent"] do
      "" -> assign(conn, :producent, %Producent{})
      id when is_binary(id) -> assign(conn, :producent, Repo.get!(Producent, id))
      _ -> assign(conn, :producent, %Producent{})
    end

  end

  @doc """
  Returns current category.
  """
  defp category(conn), do: conn.assigns.category

  @doc """
  Returns all products of given category and it's children categories.
  """
  defp current_products(conn, order_by) do
    category_descendants = conn
    |> category
    |> Category.descendants
    |> Repo.all

    Product
    |> Product.preload
    |> Product.category([category(conn) | category_descendants])
    |> Product.order_by(order_by)
  end

  @doc """
  Returns all products of given category and it's children categories.
  """
  defp current_products(conn, order_by, nil) do
    conn
    |> current_products(order_by)
    |> Repo.all
  end

  @doc """
  Returns all products of given category and it's children categories for given producent.
  """
  defp current_products(conn, order_by, producent) do
    conn
    |> current_products(order_by)
    |> Product.producent(producent)
    |> Repo.all
  end

  @doc """
  Returns breadcrumbs for given category (path from root category to current category).
  """
  defp breadcrumbs(conn) do
    breadcrumbs = conn
    |> category
    |> Category.ancestors
    |> Repo.all
    breadcrumbs ++ [category(conn)]
  end
  @doc """
  Returns breadcrumbs for given category (path from root category to given category).
  """
  defp breadcrumbs(conn, category) do
    breadcrumbs = category
    |> Category.ancestors
    |> Repo.all
    breadcrumbs ++ [category(conn)]
  end

  @doc """
  Returns siblings of current category + current category.
  """
  defp get_categories(conn) do
    categories = conn
    |> category
    |> Category.siblings
    |> Repo.all
    categories ++ [category(conn)]
    |> Enum.sort_by(&(&1.name))
  end

  @doc """
  Returns producents for given category and it's children categories.
  """
  def producents(conn) do
    category_descendants = conn
    |> category
    |> Category.descendants
    |> Repo.all

    Producent
    |> Producent.for_category([category(conn) | category_descendants])
    |> Ecto.Query.limit(10)
    |> Repo.all
  end
end
