defmodule TodoClientWeb.TodoListLive.List do
  use TodoClientWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="live-todo-list">
      <%= for todo <- assigns.todos do %>
        <div class="flex mb-4 items-center">
          <p class="todo-description-priority">
            <%= todo.priority %>)
          </p>
          <%= if todo.is_done == true do %>
            <p class="todo-description-done">
              <%= todo.description %>
            </p>
            <button id={"mark-as-not-done-#{todo.priority}"} class="btn-not-done" phx-click="done-todo" phx-value-priority={todo.priority}>Not Done</button>
          <% else %>
            <p class="todo-description-default">
              <%= todo.description %>
            </p>
            <button id={"mark-as-not-done-#{todo.priority}"} class="btn-done" phx-click="not-done-todo" phx-value-priority={todo.priority}>Done</button>
            <% end %>
          <button class="btn-remove" phx-click="delete-todo" phx-value-priority={todo.priority}>Remove</button>
        </div>
      <% end %>
    </div>
    """
  end
end
