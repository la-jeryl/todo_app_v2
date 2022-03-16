defmodule TodoClientWeb.TodosLive do
  use TodoClientWeb, :live_view
  alias TodoClient.TodoList
  alias TodoClient.Accounts

  def(mount(_params, %{"user_token" => user_token} = _session, socket)) do
    socket = socket |> assign(:current_user, Accounts.get_user_by_session_token(user_token))
    {:ok, fetch(socket)}
  end

  def handle_event("create-todo", %{"todo" => todo}, socket) do
    TodoList.new_todo(21, %{todo: todo})
    {:noreply, fetch(socket)}
  end

  def handle_event("delete-todo", %{"priority" => priority}, socket) do
    TodoList.delete_todo_by_priority(21, String.to_integer(priority))
    {:noreply, fetch(socket)}
  end

  def handle_event("done-todo", %{"priority" => priority}, socket) do
    TodoList.edit_todo_by_priority(21, String.to_integer(priority), %{todo: %{is_done: false}})
    {:noreply, fetch(socket)}
  end

  def handle_event("not-done-todo", %{"priority" => priority}, socket) do
    TodoList.edit_todo_by_priority(21, String.to_integer(priority), %{todo: %{is_done: true}})
    {:noreply, fetch(socket)}
  end

  def handle_event(
        "dropped",
        %{"currentPriority" => current_priority, "proposedPriority" => proposed_priority},
        socket
      ) do
    TodoList.edit_todo_by_priority(21, String.to_integer(current_priority), %{
      todo: %{priority: proposed_priority}
    })

    {:noreply, fetch(socket)}
  end

  def fetch(socket) do
    list = TodoList.get_list(21)["data"]
    todo_list = TodoList.get_all_todos(list["id"])["data"]
    assign(socket, todos: todo_list, list_name: list["list_name"])
  end
end
