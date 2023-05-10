defmodule RemoteApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    base_children = [
      # Start the Telemetry supervisor
      RemoteApiWeb.Telemetry,
      # Start the Ecto repository
      RemoteApi.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: RemoteApi.PubSub},
      # Start the Endpoint (http/https)
      RemoteApiWeb.Endpoint
      # Start a worker by calling: RemoteApi.Worker.start_link(arg)
      # {RemoteApi.Worker, arg}
    ]

    # Do not start RemoteApi.PointsUpdater during tests
    children =
      case Mix.env() do
        :test -> base_children
        _ -> base_children ++ [RemoteApi.PointsUpdater]
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RemoteApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RemoteApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
