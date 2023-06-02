defmodule WcsBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      WcsBotWeb.Telemetry,
      # Start the Ecto repository
      WcsBot.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: WcsBot.PubSub},
      # Start Finch
      {Finch, name: WcsBot.Finch},
      # Start the Endpoint (http/https)
      WcsBotWeb.Endpoint
      # Start a worker by calling: WcsBot.Worker.start_link(arg)
      # {WcsBot.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WcsBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WcsBotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
