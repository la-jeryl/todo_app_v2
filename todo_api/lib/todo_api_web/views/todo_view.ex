defmodule TodoApiWeb.TodoView do
  use TodoApiWeb, :view
  alias TodoApiWeb.TodoView

  def render("index.json", %{todos: todos}) do
    %{status: "TODOS_FOUND", data: render_many(todos, TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{status: "TODO_FOUND", data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{
      id: todo.id,
      priority: todo.priority,
      description: todo.description,
      is_done: todo.is_done
    }
  end

  def render("delete_todo.json", %{message: message}) do
    %{message: message}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end
