# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :phoenix_rest,
    ecto_repos: [PhoenixRest.Repo],
    generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :phoenix_rest, PhoenixRestWeb.Endpoint,
    url: [host: "localhost"],
    adapter: Phoenix.Endpoint.Cowboy2Adapter,
    render_errors: [
        formats: [json: PhoenixRestWeb.ErrorJSON],
        layout: false
    ],
    pubsub_server: PhoenixRest.PubSub,
    live_view: [signing_salt: "mJcH9/h0"]

# Configures Elixir's Logger
config :logger, :console,
    format: "$time $metadata[$level] $message\n",
    metadata: [:request_id]

config :phoenix_rest, PhoenixRestWeb.Auth.Guardian,
    issuer: "phoenix_rest",
    secret_key: System.get_env("GUARDIAN_SECRET")

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :guardian, Guardian.DB,
    repo: PhoenixRest.Repo,
    schema_name: "session_tokens",
    sweep_interval: 60

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
