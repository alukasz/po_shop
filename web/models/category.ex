defmodule PoShop.Category do
  use PoShop.Web, :model
  use Arbor.Tree

  schema "categories" do
    field :name, :string
    belongs_to :parent, PoShop.Category

    timestamps()
  end

  def order_by_name(query) do
    query
    |> order_by(asc: :name)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :parent_id])
    |> validate_required([:name])
  end
end
