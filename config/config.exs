# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :po_shop,
  ecto_repos: [PoShop.Repo]

# Configures the endpoint
config :po_shop, PoShop.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "LH3SWNSkpk5GLXqSbjpa8+qL71d0BbUiz2u05PO0cWGTdY1xbjFIIDdMrHBQGs3J",
  render_errors: [view: PoShop.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PoShop.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
