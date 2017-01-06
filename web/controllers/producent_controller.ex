defmodule PoShop.ProducentController do
  use PoShop.Web, :controller
  alias PoShop.Repo
  alias PoShop.Producent

  plug :scrub_params, "producent" when action in [:create]

  def index(conn, _params) do
    producents = Producent
    |> Repo.all

    render conn, "index.html", producents: producents
  end

  def new(conn, _params) do
    changeset = Producent.changeset(%Producent{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"producent" => producent_params}) do
    changeset = Producent.changeset(%Producent{}, producent_params)

    case Repo.insert(changeset) do
      {:ok, _cagetory} ->
        conn
        |> put_flash(:info, "Kategoria została utworzona")
        |> redirect(to: producent_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
