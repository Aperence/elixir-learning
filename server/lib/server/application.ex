defmodule Server.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # strategy for local deployement
    """
    topologies = [
      chat: [
        strategy: Cluster.Strategy.Gossip
      ]
    ]
    """
    topologies = [
      k8s_chat: [
        strategy: Elixir.Cluster.Strategy.Kubernetes.DNS,
          config: [
            service: "server-nodes",
            application_name: "server"
          ]
        ]
      ]

    children = [
      ServerWeb.Telemetry,
      Server.Repo,
      {Cluster.Supervisor, [topologies, [name: Chat.ClusterSupervisor]]},   # connect to other nodes in the cluster
      {DNSCluster, query: Application.get_env(:server, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Server.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Server.Finch},
      # Start a worker by calling: Server.Worker.start_link(arg)
      # {Server.Worker, arg},
      # Start to serve requests, typically the last entry
      ServerWeb.Endpoint,
      ServerWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Server.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
