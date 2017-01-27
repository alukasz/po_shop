defmodule PoShop.Product do
  use PoShop.Web, :model

  @moduledoc """
  Represents Product.
  """

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :float
    field :stock, :integer
    belongs_to :producent, PoShop.Producent
    belongs_to :category, PoShop.Category

    timestamps()
  end

  def search(query, search_term, limit \\ 0.3) do
    from(p in query,
    where: fragment("similarity(?, ?) > ?", p.name, ^search_term, ^limit),
    order_by: fragment("similarity(?, ?) DESC", p.name, ^search_term))
  end

  @doc """
  Preloads categories and producents
  """
  def preload(query) do
    query
    |> join(:inner, [p], c in assoc(p, :category))
    |> preload([p, c], [category: c])
    |> join(:inner, [p], m in assoc(p, :producent))
    |> preload([p, _c, m], [producent: m])
  end

  @doc """
  Limit products to given category
  """
  def category(query, categories) when is_list(categories) do
    categories = Enum.map(categories, &(&1.id))
    query
    |> where([_p, c], c.id in ^categories)
  end
  @doc """
  Limit products to given category
  """
  def category(query, category) do
    query
    |> where([_p, c], c.id == ^category.id)
  end

  def order_by(query, clause) do
    case clause do
      "price" -> query |> order_by([p, _c, _m], asc: p.price)
      "producent" -> query |> order_by([_p, _c, m], asc: m.name)
      _ -> query |> order_by([p, _c, _m], asc: p.name)
    end
  end

  def producent(query, ""), do: query

  def producent(query, producent_id) do
    query
    |> where([_p, _c, m], m.id == ^producent_id)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :price, :stock, :producent_id, :category_id])
    |> validate_required([:name, :description, :price, :stock, :producent_id, :category_id])
  end
end
