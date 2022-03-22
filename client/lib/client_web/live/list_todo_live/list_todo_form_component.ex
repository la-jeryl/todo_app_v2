defmodule ClientWeb.ListTodoLive.ListTodoFormComponent do
  use ClientWeb, :live_component

  alias Client.Todos
  alias Client.Todos.Todo

  alias Ecto.Changeset

  @impl true
  def update(%{todo: todo} = assigns, socket) do
    todo_changeset =
      Changeset.cast(
        %Todo{
          title: todo.title,
          description: todo.description,
          priority: todo.priority,
          is_done: todo.is_done
        },
        %{},
        [
          :title,
          :description,
          :priority,
          :is_done
        ]
      )

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:todo_changeset, todo_changeset)}
  end

  @impl true
  def handle_event("save", %{"todo" => todo_params}, socket) do
    save_todo(socket, socket.assigns.action, todo_params)
  end

  defp save_todo(socket, :edit, todo_params) do
    with true <- todo_params["priority"] != "",
         {:ok, _todo} <-
           Todos.update_todo(
             socket.assigns.token,
             socket.assigns.id |> String.to_integer(),
             socket.assigns.todo.id,
             %{
               todo: %{
                 title: todo_params["title"],
                 description: todo_params["description"],
                 priority: todo_params["priority"] |> String.to_integer(),
                 is_done: todo_params["is_done"] |> String.to_existing_atom()
               }
             }
           ) do
      {:noreply,
       socket
       |> put_flash(:info, "Todo updated successfully")
       |> push_redirect(to: "/lists/#{socket.assigns.id}/todos")}
    else
      false ->
        {:noreply,
         socket
         |> put_flash(:error, "Priority should not be empty.")
         |> push_redirect(to: "/lists/#{socket.assigns.id}/todos")}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "#{reason["error"]}")
         |> push_redirect(to: "/lists/#{socket.assigns.id}/todos")}
    end
  end

  defp save_todo(socket, :new, todo_params) do
    with true <- todo_params["priority"] != "",
         {:ok, _todo_item} <-
           Todos.create_todo(socket.assigns.token, String.to_integer(socket.assigns.id), %{
             todo: %{
               title: todo_params["title"],
               description: todo_params["description"],
               priority: todo_params["priority"] |> String.to_integer(),
               is_done: todo_params["is_done"] |> String.to_existing_atom()
             }
           }) do
      {:noreply,
       socket
       |> put_flash(:info, "Todo created successfully")
       |> push_redirect(to: "/lists/#{socket.assigns.id}/todos")}
    else
      false ->
        {:noreply,
         socket
         |> put_flash(:error, "Priority should not be empty.")
         |> push_redirect(to: "/lists/#{socket.assigns.id}/todos")}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "#{reason["error"]}")
         |> push_redirect(to: "/lists/#{socket.assigns.id}/todos")}
    end
  end
end
