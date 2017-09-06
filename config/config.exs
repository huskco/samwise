# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :samwise,
  ecto_repos: [Samwise.Repo]

# Configures the endpoint
config :samwise, Samwise.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0WovTnkEIfqPvZWS0HjG9UTcHkn9G3fUI3fkTidOKzuOB13H4NZimxgTyp\
    07IQfZ",
  render_errors: [view: Samwise.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Samwise.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure Google OAuth
config :ueberauth, Ueberauth,
  providers: [
    google: {
      Ueberauth.Strategy.Google,
      [default_scope: "emails profile plus.me"]
    }
  ]
config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_AUTH_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_AUTH_CLIENT_SECRET")

# Configure Quantum to schedule tasks
config :samwise, Samwise.Scheduler,
  timezone: "America/Denver",
  jobs: [
    {"0 8 * * *", {Samwise.Slack, :post_money_summary, []}},
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
