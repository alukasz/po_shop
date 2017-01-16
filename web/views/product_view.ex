defmodule PoShop.ProductView do
  use PoShop.Web, :view

  def get_params(conn, attrs \\ %{}) do
    %{producent: get_producent(conn), sort: get_sort(conn)}
    |> Map.merge(attrs)
  end

  def get_producent(conn) do
    Map.get(conn.params, "producent", nil)
  end

  def get_sort(conn) do
    Map.get(conn.params, "sort", nil)
  end

  def breadcrumbs(conn, categories) do
    breadcrumbs(conn, [], categories)
  end

  def same(%{__struct__: struct1, id: id1}, %{__struct__: struct2, id: id2})
    when id1 == id2 and struct1 == struct2, do: "is-active"
  def same(_a, _b), do: ""

  def subcategories(conn, %PoShop.Category{id: id1} = category, %PoShop.Category{id: id2})
    when id1 == id2 do
    categories = category
    |> PoShop.Category.children
    |> PoShop.Repo.all
    format_subcategories(conn, Enum.sort_by(categories, &(&1.name)))
  end

  def subcategories(_conn, _, _), do: ""

  defp format_subcategories(_conn, []), do: ""
  defp format_subcategories(conn, categories) when is_list(categories) do
    content_tag :ul do
      for category <- categories do
        content_tag :li do
          link category.name, to: category_product_path(conn, :index, category)
        end
      end
    end
  end

  defp breadcrumbs(_conn, io_list, []), do: io_list
  defp breadcrumbs(conn, io_list, [category | categories]) when length(categories) == 0 do
    [breadcrumb_link(conn, category, "is-disabled")
      | breadcrumbs(conn, io_list, categories)]
  end
  defp breadcrumbs(conn, io_list, [category | categories]) do
    [breadcrumb_link(conn, category), breadcrumb_separator()
      | breadcrumbs(conn, io_list, categories)]
  end

  defp breadcrumb_link(conn, category, disabled \\ "") do
    link(category.name, to: category_product_path(conn, :index, category, get_params(conn)), class: "button is-link #{disabled}")
  end
  defp breadcrumb_separator do
    content_tag :span, " > ", class: "button is-link is-disabled", style: "text-decoration: none"
  end
end
