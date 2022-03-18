defmodule TodoApiWeb.TodoView do
  use TodoApiWeb, :view
  alias TodoApiWeb.TodoView

  def render("index.json", %{todos: todos}) do
    %{data: render_many(todos, TodoView, "todo.json")}
  end

  def render("show.json", %{todo: todo}) do
    %{data: render_one(todo, TodoView, "todo.json")}
  end

  def render("todo.json", %{todo: todo}) do
    %{
      id: todo.id,
      priority: todo.priority,
      title: todo.title,
      description: todo.description,
      is_done: todo.is_done
    }
  end

  def render("delete_todo.json", %{message: message}) do
    %{data: %{message: message}}
  end

  def render("error.json", %{error: error}) do
    %{error: %{error: error}}
  end
end
