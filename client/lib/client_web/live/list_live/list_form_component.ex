defmodule ClientWeb.ListLive.ListFormComponent do
  use ClientWeb, :live_component

  alias Client.Lists
  alias Client.Lists.List
  alias Client.Helpers

  alias Ecto.Changeset

  @impl true
  def update(%{list: list} = assigns, socket) do
    changeset =
      Changeset.cast(
        %List{
          list_name: list.list_name,
          user_id: list.user_id
        },
        %{},
        [
          :list_name,
          :user_id
        ]
      )

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"list" => list_params}, socket) do
    save_list(socket, socket.assigns.action, list_params)
  end

  defp save_list(socket, :edit, list_params) do
    list_body = Map.put(list_params, "user_id", socket.assigns.user_id)

    case Lists.update_list(socket.assigns.token, socket.assigns.list.id, %{
           list: Helpers.keys_to_atoms(list_body)
         }) do
      {:ok, _list} ->
        {:noreply,
         socket
         |> put_flash(:info, "List updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "#{reason["error"]}")
         |> push_redirect(to: "/lists")}
    end
  end

  defp save_list(socket, :new, list_params) do
    list_body = Map.put(list_params, "user_id", socket.assigns.user_id)

    case Lists.create_list(socket.assigns.token, %{list: Helpers.keys_to_atoms(list_body)}) do
      {:ok, _list} ->
        {:noreply,
         socket
         |> put_flash(:info, "List created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, reason} ->
        {:noreply,
         socket
         |> put_flash(:error, "#{reason["error"]}")
         |> push_redirect(to: "/lists")}
    end
  end
end
