defmodule TodoClient.Repo do
  use Ecto.Repo,
    otp_app: :todo_client,
    adapter: Ecto.Adapters.Postgres
end
