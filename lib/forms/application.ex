defmodule Forms.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FormsWeb.Telemetry,
      Forms.Repo,
      {DNSCluster, query: Application.get_env(:forms, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Forms.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Forms.Finch},
      # Start a worker by calling: Forms.Worker.start_link(arg)
      # {Forms.Worker, arg},
      # Start to serve requests, typically the last entry
      FormsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Forms.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FormsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
