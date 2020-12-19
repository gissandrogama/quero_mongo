defmodule QueromongoApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      QueromongoApiWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: QueromongoApi.PubSub},
      # Start the Endpoint (http/https)
      QueromongoApiWeb.Endpoint,
      # Start a worker by calling: QueromongoApi.Worker.start_link(arg)
      # {QueromongoApi.Worker, arg}
      {Mongo,
       [
         name: :mongo,
         url: "mongodb+srv://cluster0.dbgv6.mongodb.net/<quero_db>",
         username:  System.get_env("USER_MONGO"),
         password: System.get_env("PASSWD_MONGO"),
         pool_size: 10
       ]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QueromongoApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    QueromongoApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
