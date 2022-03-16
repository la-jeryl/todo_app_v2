defmodule TodoApiWeb.Router do
  use TodoApiWeb, :router
  use Pow.Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  scope "/api" do
    pipe_through :api

    pow_routes()
  end

  scope "/api", TodoApiWeb do
    pipe_through [:api, :protected]

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
