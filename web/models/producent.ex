defmodule PoShop.Producent do
  use PoShop.Web, :model

  schema "producents" do
    field :name, :string

    timestamps()
  end

  def for_category(query, categories) do
    categories = Enum.map(categories, &(&1.id))

    query
    |> distinct(true)
    |> join(:inner, [m], p in PoShop.Product, m.id == p.producent_id)
    |> join(:inner, [m, p], c in PoShop.Category, c.id == p.category_id)
    |> where([m, p, c], c.id in ^categories)
    |> order_by([m, p, c], asc: m.name)
    |> select([m, p, c], struct(m, [:id, :name]))
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
