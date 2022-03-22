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

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :todo_api,
      swagger_file: "swagger.json"
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Todo Api App",
        description: "API Documentation for Todo API App"
      },
      securityDefinitions: %{
        Headers: %{
          type: "access_token",
          name: "Authorization",
          description: "API Token must be provided via `Authorization: Headers ` header",
          in: "header"
        }
      },
      consumes: ["application/json"],
      produces: ["application/json"],
      tags: [
        %{name: "Registration", description: "Registration resources"},
        %{name: "Session", description: "Session resources"},
        %{name: "Lists", description: "Lists resources"},
        %{name: "Todos", description: "Todos resources"}
      ]
    }
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
