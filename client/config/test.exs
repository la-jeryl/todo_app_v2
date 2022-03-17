import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :client, Client.Repo,
  username: "jeryl",
  password: "testing",
  hostname: "localhost",
  database: "client_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :client, ClientWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4042],
  secret_key_base: "w6OCCiWUTxrTcDQhhdyU0ep4E+zAjVuBUT7E2vEPBpxujpwCQ5/Wubpo6AVOlzY4",
  server: false

# In test we don't send emails.
config :client, Client.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
