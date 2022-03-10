defmodule TodoApiWeb.ListView do
  use TodoApiWeb, :view
  alias TodoApiWeb.{ListView, TodoView}

  def render("index.json", %{lists: lists}) do
    %{data: render_many(lists, ListView, "list_with_todos.json")}
  end

  def render("show.json", %{list: list}) do
    %{data: render_one(list, ListView, "list_with_todos.json")}
  end

  def render("list_with_todos.json", %{list: list}) do
    %{
      id: list.id,
      user_id: list.user_id,
      list_name: list.list_name,
      todos: render_many(list.todos, TodoView, "todo.json")
    }
  end

  def render("delete_list_with_todos.json", %{message: message}) do
    %{message: message}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end
