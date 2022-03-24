defmodule Client.Registrations do
  use Tesla

  # plug Tesla.Middleware.BaseUrl, "http://localhost:4000/api"
  plug(Tesla.Middleware.BaseUrl, "192.168.64.2:4000/api")
  plug(Tesla.Middleware.JSON)

  def register(email, password, password_confirmation) do
    with true <- password == password_confirmation,
         {:ok, response} <-
           post("/registration", %{
             user: %{
               email: email,
               password: password,
               password_confirmation: password_confirmation
             }
           }) do
      case Map.has_key?(response.body, "data") do
        true ->
          {:ok, response.body["data"]}

        false ->
          {:error, response.body["error"]}
      end
    else
      false -> {:error, "Passwords do not match"}
      {:error, reason} -> {:error, reason}
    end
  end
end
