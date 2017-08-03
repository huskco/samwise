use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :samwise, Samwise.Endpoint,
  secret_key_base: "cJ2hh1RfIYS1jwZeG0UZkqdf406wOqbsz2h/JR7qbA2RDmM4gmoWW+adaARGsJ1s"

# Configure your database
config :samwise, Samwise.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: System.get_env("DATABASE_URL"),
  username: System.get_env("DATABASE_USER"),
  password: System.get_env("DATABASE_PASS"),
  pool_size: 20
