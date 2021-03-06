# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :queromongo_api, QueromongoApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JVMjIiVw1maP48+upURikfFtIFYNM8eNFnWl9T2T3Mygy4EU1b2WdfrwCi6qJ4Ma",
  render_errors: [view: QueromongoApiWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: QueromongoApi.PubSub,
  live_view: [signing_salt: "cPZyKOrf"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :queromongo_api, QueromongoApiWeb.Guardian,
  issuer: "queromongo_api",
  secret_key: "K91m8H8WRKxJXwyGE6zIPJMdNteh//yMyxj8DKCi+ccs2I1KlzEwfLT9zdBy7uQG"

# Configures Guardian module and error handler
config :queromongo_api, QueromongoApiWeb.AuthAccessPipeline,
  module: QueromongoApiWeb.Guardian,
  error_handler: QueromongoApiWeb.AuthErrorHandler

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
