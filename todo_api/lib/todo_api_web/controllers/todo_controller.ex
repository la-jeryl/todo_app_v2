defmodule TodoApiWeb.TodoController do
  use TodoApiWeb, :controller

  alias TodoApi.Todos
  alias TodoApi.Todos.Todo
  alias TodoApi.Lists

  action_fallback TodoApiWeb.FallbackController

  def index(conn, %{"list_id" => list_id}) do
    with {:ok, list} <- Lists.get_list_by_id(list_id) do
      render(conn, "index.json", todos: list.todos)
    else
      {_, reason} -> conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def create(conn, %{"list_id" => list_id, "todo" => todo_params}) do
    with {:ok, list} = Lists.get_list_by_id(list_id),
         {:ok, %Todo{} = todo} <- Todos.create_todo(list, todo_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.list_todo_path(conn, :show, list_id, todo))
      |> render("show.json", todo: todo)
    else
      {:error, reason} -> conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, todo} <- Todos.get_todo_by_id(id) do
      render(conn, "show.json", todo: todo)
    else
      {_, reason} ->
        conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    with {:ok, todo} <- Todos.get_todo_by_id(id),
         {:ok, %Todo{} = todo} <- Todos.update_todo(todo, todo_params) do
      render(conn, "show.json", todo: todo)
    else
      {_, reason} ->
        conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, todo} <- Todos.get_todo_by_id(id),
         {:ok, _todo} <- Todos.delete_todo(todo) do
      render(conn, "delete_todo.json", message: "'#{todo.description}' todo was deleted.")
    else
      {_, reason} ->
        conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end
end
