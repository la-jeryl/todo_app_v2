import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :client, Client.Repo,
  username: "jeryl",
  password: "testing",
  hostname: "localhost",
  database: "client_test#{System.get_env("MIX_TEST_PARTITION")}_5",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :client, ClientWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4052],
  secret_key_base: "kSXAIGKxBSzQZ9Mbp5G0omAQame9GoZVLP1DckFUx4Va0TUsafxlnO2EKiU/sBHk",
  server: false

# In test we don't send emails.
config :client, Client.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
