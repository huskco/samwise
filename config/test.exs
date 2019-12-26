use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :samwise, Samwise.Endpoint,
  http: [port: 4001],
  server: true

config :samwise, :sql_sandbox, true

config :slack, url: "http://localhost:8000"

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :samwise, Samwise.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "samwise_original_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
