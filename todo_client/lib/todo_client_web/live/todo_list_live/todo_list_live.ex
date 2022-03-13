defmodule TodoClientWeb.TodoListLive do
  use TodoClientWeb, :live_view
  alias TodoClient.TodoList

  def(mount(_params, _session, socket)) do
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

  def render(assigns) do
    ~H"""
    <div class="self-center h-100 w-full flex items-center justify-center font-sans">
      <div class="section-main">
        <.live_component module={__MODULE__.Input} id="todo-input" />
        <%= if @todos do %>
          <.live_component module={__MODULE__.List} id="todo-list" todos={@todos}/>
        <% else%>
          <h3>Make your first todo.</h3>
        <% end %>
      </div>
    </div>
    """
  end

  def fetch(socket) do
    todo_list = TodoList.get_all_todos(1)["data"]
    assign(socket, todos: todo_list)
  end
end
