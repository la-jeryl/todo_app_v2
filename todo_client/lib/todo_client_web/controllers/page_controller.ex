defmodule TodoClientWeb.PageController do
  use TodoClientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
