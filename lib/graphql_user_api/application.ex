defmodule GraphqlUserApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      GraphqlUserApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: GraphqlUserApi.PubSub},
      # Start Finch
      {Finch, name: GraphqlUserApi.Finch},
      # Start the Endpoint (http/https)
      GraphqlUserApiWeb.Endpoint,
      {Absinthe.Subscription, GraphqlUserApiWeb.Endpoint},
      GraphqlUserApi.Repo,
      GraphqlUserApi.ResolverHits.Store
      # Start a worker by calling: GraphqlUserApi.Worker.start_link(arg)
      # {GraphqlUserApi.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GraphqlUserApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GraphqlUserApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
