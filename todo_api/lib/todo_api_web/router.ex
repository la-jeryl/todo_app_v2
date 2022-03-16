defmodule TodoApiWeb.Router do
  use TodoApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug TodoApiWeb.APIAuthPlug, otp_app: :todo_api
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: TodoApiWeb.APIAuthErrorHandler
  end

  scope "/api", TodoApiWeb do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api", TodoApiWeb do
    pipe_through [:api, :api_protected]

    resources "/lists", ListController, except: [:new, :edit] do
      resources "/todos", TodoController, except: [:new, :edit]
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
