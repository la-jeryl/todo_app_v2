defmodule ClientWeb.UserSessionController do
  use ClientWeb, :controller

  # alias Client.Accounts
  alias ClientWeb.UserAuth

  alias Client.Sessions

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    # if user = Accounts.get_user_by_email_and_password(email, password) do
    #   UserAuth.log_in_user(conn, user, user_params)
    # else
    case Sessions.login(email, password) do
      {:ok, session_details} ->
        UserAuth.log_in_user(conn, session_details)

      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      {:error, error_details} ->
        render(conn, "new.html", error_message: error_details["message"])
    end
  end

  def delete(conn, _params) do
    user_token = Plug.Conn.get_session(conn, :user_token)
    Sessions.logout(user_token)

    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
