defmodule ClientWeb.ListTodoLive.Index do
  use ClientWeb, :live_view

  alias Client.Todos
  alias Client.Todos.Todo

  @impl true
  def mount(params, session, socket) do
    case Todos.list_todos(session["user_token"], params["list_id"]) do
      {:ok, todos} ->
        {:ok,
         socket
         |> assign(:list_id, params["list_id"])
         |> assign(:token, session["user_token"])
         |> assign(:user_id, session["current_user"]["id"])
         |> assign(:todos, todos)}

      {:error, reason} ->
        {:ok,
         socket
         |> put_flash(:error, "Login again. #{reason["message"]}.")
         |> redirect(to: "/")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"list_id" => list_id, "todo_id" => todo_id}) do
    with {:ok, todo} <- Todos.get_todo(socket.assigns.token, list_id, todo_id) do
      socket
      |> assign(:token, socket.assigns.token)
      |> assign(:user_id, socket.assigns.user_id)
      |> assign(:page_title, "Edit Todo")
      |> assign(:todo, todo)
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:token, socket.assigns.token)
    |> assign(:user_id, socket.assigns.user_id)
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:token, socket.assigns.token)
    |> assign(:user_id, socket.assigns.user_id)
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    token = socket.assigns.token
    list_id = String.to_integer(socket.assigns.list_id)

    case Todos.delete_todo(token, list_id, id) do
      {:ok, response} ->
        {:noreply,
         socket
         |> assign(:todos, list_todos(token, list_id))
         |> put_flash(:info, "#{response["message"]}")
         |> push_redirect(to: "/lists/#{list_id}/todos")}

      {:error, reason} ->
        {:noreply,
         socket
         |> assign(:todos, list_todos(token, list_id))
         |> put_flash(:error, "#{reason["message"]}")
         |> push_redirect(to: "/lists/#{list_id}/todos")}
    end
  end

  @impl true
  def handle_event(
        "dropped",
        %{"draggableIndex" => new_index, "draggedId" => todo_id} = _params,
        socket
      ) do
    token = socket.assigns.token
    list_id = String.to_integer(socket.assigns.list_id)

    case Todos.update_todo(token, list_id, String.to_integer(todo_id), %{
           todo: %{priority: new_index + 1}
         }) do
      {:ok, _response} ->
        {:noreply,
         socket
         |> assign(:todos, list_todos(token, list_id))
         |> put_flash(:info, "Todo updated successfully")
         |> push_redirect(to: "/lists/#{list_id}/todos")}

      {:error, reason} ->
        {:noreply,
         socket
         |> assign(:todos, list_todos(token, list_id))
         |> put_flash(:error, "#{reason["message"]}")
         |> push_redirect(to: "/lists/#{list_id}/todos")}
    end
  end

  defp list_todos(token, list_id) do
    case Todos.list_todos(token, list_id) do
      {:ok, list_of_todos} ->
        list_of_todos

      {:error, reason} ->
        {:error, reason}
    end
  end
end
