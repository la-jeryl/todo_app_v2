defmodule TodoApiWeb.TodoController do
  use TodoApiWeb, :controller

  alias TodoApi.Todos
  alias TodoApi.Todos.Todo
  alias TodoApi.Lists

  action_fallback TodoApiWeb.FallbackController

  def index(conn, %{"list_id" => list_id}) do
    list = Lists.get_list!(list_id)
    render(conn, "index.json", todos: list.todos)
  end

  def create(conn, %{"list_id" => list_id, "todo" => todo_params}) do
    list = Lists.get_list!(list_id)

    with {:ok, %Todo{} = todo} <- Todos.create_todo(list, todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.list_todo_path(conn, :show, list_id, todo))
      |> render("show.json", todo: todo)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)
    render(conn, "show.json", todo: todo)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Todos.get_todo!(id)

    with {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, "show.json", todo: todo)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id)

    with {:ok, %Todo{}} <- Todos.delete_todo(todo) do
      send_resp(conn, :no_content, "")
    end
  end
end
