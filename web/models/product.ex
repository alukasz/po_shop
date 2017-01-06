defmodule PoShop.Product do
  use PoShop.Web, :model

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :float
    field :stock, :integer
    belongs_to :producent, PoShop.Producent
    belongs_to :category, PoShop.Category

    timestamps()
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

    # |> select([p, c, m], {p, c, m})
    # |> select([p, c, m], %{price: p.price, name: p.name, category: c.name, producent: m.name})
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
    clause = case clause do
      "price" -> query |> order_by([p, _c, _m], asc: p.price)
      "producent" -> query |> order_by([_p, _c, m], asc: m.name)
      _ -> query |> order_by([p, _c, _m], asc: p.name)
    end

  end

  def producent(query, "") do
    query
  end

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
