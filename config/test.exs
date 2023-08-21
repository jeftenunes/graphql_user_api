import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :graphql_user_api, GraphqlUserApiWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "vfgbk8i9W/mZcgEHXEN+CEbz1Rmc+n6+VXVRokKsUGutspx/tQ6CnvzYO4kILXhn",
  server: false

config :graphql_user_api, GraphqlUserApi.Repo,
  database: "graphql_user_api_repo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# In test we don't send emails.
config :graphql_user_api, GraphqlUserApi.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
