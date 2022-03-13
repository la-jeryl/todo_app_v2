defmodule TodoClientWeb.TodosLive do
  use TodoClientWeb, :live_view
  alias TodoClient.TodoList
  alias TodoClient.Accounts
  alias TodoClientWeb.TodosLive.Components

  def(mount(_params, %{"user_token" => user_token} = _session, socket)) do
    socket = socket |> assign(:current_user, Accounts.get_user_by_session_token(user_token))
    {:ok, fetch(socket)}
  end

  def handle_event("create-todo", %{"todo" => todo}, socket) do
    TodoList.new_todo(1, %{todo: todo})
    {:noreply, fetch(socket)}
  end

  def handle_event("delete-todo", %{"priority" => priority}, socket) do
    TodoList.delete_todo_by_priority(1, String.to_integer(priority))
    {:noreply, fetch(socket)}
  end

  def handle_event("done-todo", %{"priority" => priority}, socket) do
    TodoList.edit_todo_by_priority(1, String.to_integer(priority), %{todo: %{is_done: false}})
    {:noreply, fetch(socket)}
  end

  def handle_event("not-done-todo", %{"priority" => priority}, socket) do
    TodoList.edit_todo_by_priority(1, String.to_integer(priority), %{todo: %{is_done: true}})
    {:noreply, fetch(socket)}
  end

  def handle_event(
        "dropped",
        %{"currentPriority" => current_priority, "proposedPriority" => proposed_priority},
        socket
      ) do
    TodoList.edit_todo_by_priority(1, String.to_integer(current_priority), %{
      todo: %{priority: proposed_priority}
    })

    {:noreply, fetch(socket)}
  end

  def fetch(socket) do
    todo_list = TodoList.get_all_todos(1)["data"]
    assign(socket, todos: todo_list)
  end
end
