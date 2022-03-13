defmodule TodoClientWeb.TodoListLive.List do
  use TodoClientWeb, :live_component
  alias TodoClient.TodoList
  alias TodoClientWeb.TodoListLive

  def mount(socket) do
    {:ok, socket}
  end

  def handle_event(
        "dropped",
        %{
          "currentPriority" => current_priority,
          "proposedPriority" => proposed_priority
        },
        socket
      ) do
    TodoList.edit_todo_by_priority(1, String.to_integer(current_priority), %{
      todo: %{priority: proposed_priority}
    })

    {:noreply, TodoListLive.fetch(socket)}
  end

  def render(assigns) do
    ~H"""
    <div phx-hook="Drag" id="drag">
      <div class="dropzone grid gap-3" id="pool">
        <%= for todo <- @todos do %>
          <div draggable="true" id={"#{todo["priority"]}"} class="draggable flex mb-4 items-center sortable-ghost">
            <p class="todo-title-priority">
              <%= todo["priority"] %>)
            </p>
            <%= if todo["is_done"] == true do %>
              <p class="todo-title-done">
                <%= todo["title"] %>
              </p>
              <button id={"mark-as-not-done-#{todo["priority"]}"} class="btn-not-done" phx-click="done-todo" phx-value-priority={todo["priority"]}>Not Done</button>
            <% else %>
              <p class="todo-title-default">
                <%= todo["title"] %>
              </p>
              <button id={"mark-as-not-done-#{todo["priority"]}"} class="btn-done" phx-click="not-done-todo" phx-value-priority={todo["priority"]}>Done</button>
              <% end %>
            <button class="btn-remove" phx-click="delete-todo" phx-value-priority={todo["priority"]}>Remove</button>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
