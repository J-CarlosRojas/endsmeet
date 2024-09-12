defmodule Endsmeet.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      EndsmeetWeb.Telemetry,
      Endsmeet.Repo,
      {DNSCluster, query: Application.get_env(:endsmeet, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Endsmeet.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Endsmeet.Finch},
      # Start a worker by calling: Endsmeet.Worker.start_link(arg)
      # {Endsmeet.Worker, arg},
      # Start to serve requests, typically the last entry
      EndsmeetWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Endsmeet.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    EndsmeetWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
