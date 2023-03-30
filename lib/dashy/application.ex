defmodule Dashy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      DashyWeb.Telemetry,
      # Start the Ecto repository
      Dashy.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dashy.PubSub},
      # Start Finch
      {Finch, name: Dashy.Finch},
      # Start the Endpoint (http/https)
      DashyWeb.Endpoint
      # Start a worker by calling: Dashy.Worker.start_link(arg)
      # {Dashy.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dashy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DashyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
