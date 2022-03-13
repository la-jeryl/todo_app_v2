defmodule TodoClientWeb.TodosLive.Components do
  use Phoenix.Component
  use Phoenix.HTML

  def list(assigns) do
    ~H"""
    <div phx-hook="Drag" id="drag">
      <div class="dropzone grid gap-3" id="pool">
        <%= for todo <- @todos do %>
          <.todo todo={todo}/>
        <% end %>
      </div>
    </div>
    """
  end

  def input(assigns) do
    ~H"""
    <div id="live-todo-input">
      <form action="#" phx-submit="create-todo" class="flex mt-4 mb-4">
        <%= text_input :todo, "title", placeholder: "Add todo",  class: "input-todo" %>
        <%= submit "Add", class: "btn-add" %>
      </form>
    </div>
    """
  end

  def todo(assigns) do
    %{"priority" => priority, "is_done" => is_done, "title" => title} = assigns.todo

    ~H"""
    <div draggable="true" id={"#{priority}"} class="draggable flex items-center sortable-ghost">
      <p class="todo-title-priority">
        <%= priority %>)
      </p>
      <%= if is_done == true do %>
        <p class="todo-title-done">
          <%= title %>
        </p>
        <button id={"mark-as-not-done-#{priority}"} class="btn-not-done" phx-click="done-todo" phx-value-priority={priority}>Not Done</button>
      <% else %>
        <p class="todo-title-default">
          <%= title %>
        </p>
        <button id={"mark-as-not-done-#{priority}"} class="btn-done" phx-click="not-done-todo" phx-value-priority={priority}>Done</button>
        <% end %>
      <button class="btn-remove" phx-click="delete-todo" phx-value-priority={priority}>Remove</button>
    </div>
    """
  end
end
