defmodule PoShop.CategoryController do
  use PoShop.Web, :controller
  alias PoShop.Repo
  alias PoShop.Category

  plug :scrub_params, "category" when action in [:create]

  @doc """
  Renders all categories.
  """
  def index(conn, _params) do
    categories = Category
    |> Repo.all
    |> Repo.preload(:parent)

    render conn, "index.html", categories: categories
  end

  @doc """
  Renders form for category.
  """
  def new(conn, _params) do
    changeset = Category.changeset(%Category{})

    render conn, "new.html", changeset: changeset, categories: get_categories()
  end

  @doc """
  Inserts category in the database. If category params are invalid, rerenders form
  """
  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.insert(changeset) do
      {:ok, _cagetory} ->
        conn
        |> put_flash(:info, "Kategoria została utworzona")
        |> redirect(to: category_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset, categories: get_categories()
    end
  end

  @doc """
  Returns all categories
  """
  defp get_categories do
    categories = Category |> Repo.all
    [%Category{} | categories]
  end
end
