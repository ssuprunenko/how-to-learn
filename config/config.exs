# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :app,
  ecto_repos: [App.Repo],
  generators: [binary_id: true]

config :app, App.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  migration_foreign_key: [column: :id, type: :binary_id]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "j6Z4oGgPgRdfNuPfoX8TSTyX2sEn39ZvsDXqWnRvKbr/iHyXaXwKCUnEfMCAa6ci",
  render_errors: [view: AppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "7iG+uUul"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :kaffy,
  otp_app: :app,
  ecto_repo: App.Repo,
  router: AppWeb.Router,
  admin_title: "HTL – Admin Panel",
  resources: &App.Admin.Config.create_resources/1

config :app, :basic_auth,
  username: System.get_env("ADMIN_USERNAME", "admin"),
  password: System.get_env("ADMIN_PASSWORD", "password")

config :waffle,
  storage: Waffle.Storage.Local,
  storage_dir_prefix: System.get_env("STORAGE_ASSETS_PATH", "storage/assets/")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
