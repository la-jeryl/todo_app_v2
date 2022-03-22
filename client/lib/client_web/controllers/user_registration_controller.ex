defmodule ClientWeb.UserRegistrationController do
  use ClientWeb, :controller

  alias Client.Accounts
  alias Client.Accounts.User
  alias Client.Registrations
  alias ClientWeb.UserSessionController
  alias Ecto.Changeset

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password, "password_confirmation" => password_confirmation} =
      user_params

    case Registrations.register(email, password, password_confirmation) do
      {:ok, _session} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> UserSessionController.create(%{"user" => %{"email" => email, "password" => password}})

      {:error, reason} ->
        cond do
          is_map(reason) and Map.has_key?(reason["errors"], "email") ->
            [message] = reason["errors"]["email"]
            changeset = custom_changeset(email, password, :email, "Email #{message}", :insert)

            render(conn, "new.html", changeset: changeset)

          is_map(reason) and Map.has_key?(reason["errors"], "password") ->
            [message] = reason["errors"]["password"]

            changeset =
              custom_changeset(email, password, :password, "Password #{message}", :insert)

            render(conn, "new.html", changeset: changeset)

          true ->
            changeset = custom_changeset(email, password, :password, reason, :insert)
            render(conn, "new.html", changeset: changeset)
        end
    end
  end

  defp custom_changeset(email, password, field_atom, message, action_atom) do
    initial_changeset =
      Changeset.cast(%User{email: email, password: password}, %{}, [
        :email,
        :password
      ])

    error_changeset = Changeset.add_error(initial_changeset, field_atom, message)
    {:error, final_changeset} = Changeset.apply_action(error_changeset, action_atom)

    final_changeset
  end
end
