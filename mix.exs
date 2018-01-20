defmodule Samwise.Mixfile do
  use Mix.Project

  def project do
    [app: :samwise,
     version: "0.1.0",
     elixir: "~> 1.5.1",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Samwise, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy,
                    :logger, :gettext, :phoenix_ecto, :postgrex, :timex,
                    :ueberauth, :ueberauth_google, :ex_machina, :slack]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.3.0"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:number, "~> 0.5.1"},
     {:timex, "~> 3.1.24"},
     {:ueberauth, "~> 0.4"},
     {:ueberauth_google, "~> 0.5"},
     {:ex_machina, "~> 2.0"},
     {:credo, "~> 0.8.6"},
     {:slack, "~> 0.12.0"},
     {:quantum, "~> 2.1.0-beta.1"},
     {:wallaby, "~> 0.19.1"}]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["ecto.create --quiet", "ecto.migrate", "test",
       "credo --strict"]]
  end
end
