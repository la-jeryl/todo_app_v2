defmodule TodoClientWeb.TodoListLive.Input do
  use TodoClientWeb, :live_component

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div id="live-todo-input">
      <form action="#" phx-submit="create-todo" class="flex mt-4 mb-4">
        <%= text_input :todo, "description", placeholder: "Add todo",  class: "input-todo" %>
        <%= submit "Add", class: "btn-add" %>
      </form>
    </div>
    """
  end
end
