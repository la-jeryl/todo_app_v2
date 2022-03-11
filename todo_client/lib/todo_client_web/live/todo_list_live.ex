defmodule TodoClientWeb.TodoListLive do
  use TodoClientWeb, :live_view

  def(mount(_params, _session, socket)) do
    {:ok, fetch(socket)}
  end

  def handle_event("create-todo", %{"todo" => todo}, socket) do
    todo
    |> Todos.create_todo()

    {:noreply, fetch(socket)}
  end

  def handle_event("delete-todo", %{"priority" => priority}, socket) do
    Todos.delete_todo_by_priority(priority)
    {:noreply, fetch(socket)}
  end

  def handle_event("done-todo", %{"priority" => priority}, socket) do
    Todos.update_todo_by_priority(priority, %{is_done: false})

    {:noreply, fetch(socket)}
  end

  def handle_event("not-done-todo", %{"priority" => priority}, socket) do
    Todos.update_todo_by_priority(priority, %{is_done: true})
    {:noreply, fetch(socket)}
  end

  def render(assigns) do
    ~H"""
    <div class="self-center h-100 w-full flex items-center justify-center font-sans">
      <div class="section-main">
        <.live_component module={__MODULE__.Input} id="todo-input" />
        <.live_component module={__MODULE__.List} id="todo-list" todos={assigns.todos} />
      </div>
    </div>
    """
  end

  defp fetch(socket) do
    {:ok, todo_list} = Todos.get_all_todos()
    assign(socket, todos: todo_list)
  end
end
