# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :demo_phoenix, :scopes,
  user: [
    default: true,
    module: DemoPhoenix.Accounts.Scope,
    assign_key: :current_scope,
    access_path: [:user, :id],
    schema_key: :user_id,
    schema_type: :id,
    schema_table: :users,
    test_data_fixture: DemoPhoenix.AccountsFixtures,
    test_login_helper: :register_and_log_in_user
  ]

config :demo_phoenix,
  ecto_repos: [DemoPhoenix.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :demo_phoenix, DemoPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: DemoPhoenixWeb.ErrorHTML, json: DemoPhoenixWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: DemoPhoenix.PubSub,
  live_view: [signing_salt: "0gpWa+J+"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :demo_phoenix, DemoPhoenix.Mailer, adapter: Swoosh.Adapters.Local

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.0.9",
  demo_phoenix: [
    args: ~w(
      --input=assets/css/app.css
      --output=priv/static/assets/css/app.css
    ),
    cd: Path.expand("..", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
