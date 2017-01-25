defmodule PoShop.Router do
  use PoShop.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug NavigationHistory.Tracker
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PoShop do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/products", ProductController, only: [:new, :create]

    resources "/categories", CategoryController, only: [:index, :new, :create] do
      resources "/products", ProductController, only: [:index, :show]
    end

    resources "/producents", ProducentController, only: [:index, :new, :create]

    get "/cart", CartController, :index
    post "/cart", CartController, :create
    put "/cart", CartController, :update
    delete "/cart", CartController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", PoShop do
  #   pipe_through :api
  # end
end
