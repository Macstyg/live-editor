defmodule LiveEditor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LiveEditorWeb.Telemetry,
      LiveEditor.Repo,
      {DNSCluster, query: Application.get_env(:live_editor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LiveEditor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: LiveEditor.Finch},
      # Start a worker by calling: LiveEditor.Worker.start_link(arg)
      # {LiveEditor.Worker, arg},
      # Start to serve requests, typically the last entry
      LiveEditorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LiveEditor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LiveEditorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
