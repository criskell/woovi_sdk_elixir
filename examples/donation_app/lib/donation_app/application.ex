defmodule DonationApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      DonationAppWeb.Telemetry,
      DonationApp.Repo,
      {DNSCluster, query: Application.get_env(:donation_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: DonationApp.PubSub},
      # Start a worker by calling: DonationApp.Worker.start_link(arg)
      # {DonationApp.Worker, arg},
      # Start to serve requests, typically the last entry
      DonationAppWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DonationApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    DonationAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
