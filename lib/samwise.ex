defmodule Samwise do
  @moduledoc """
  A helpful bot for Ogles
  """
  use Application
  alias Samwise.Repo
  alias Samwise.Endpoint

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Repo, []),
      # Start the endpoint when the application starts
      supervisor(Endpoint, []),
      # Start your own worker by calling:
      # Samwise.Worker.start_link(arg1, arg2, arg3)
      # worker(Samwise.Worker, [arg1, arg2, arg3]),
      worker(Slack.Bot, [Samwise.Slack, [], System.get_env("SLACK_TOKEN")])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
