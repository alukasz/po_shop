defmodule PoShop.ProducentsControllerTest do
  use PoShop.ConnCase
  import PoShop.Factory

  test "#index lists producents", %{conn: conn} do
    producent = insert(:producent)

    conn = get conn, producent_path(conn, :index)

    assert html_response(conn, 200) =~ producent.name
  end

  test "#new has a form", %{conn: conn} do
    conn = get conn, producent_path(conn, :new)

    assert html_response(conn, 200) =~ "Dodaj"
  end

  # can't be blank

  test "#create with valid params inserts producent", %{conn: conn} do
    conn = post conn, producent_path(conn, :create), %{"producent" => %{"name" => "Nazwa producenta"}}

    assert redirected_to(conn) == producent_path(conn, :index)
  end

  test "#create with invalid params rerenders form", %{conn: conn} do
    conn = post conn, producent_path(conn, :create), %{"producent" =>
      %{"name" => ""}
    }

    assert html_response(conn, 200) =~ "can&#39;t be blank"
  end
end
