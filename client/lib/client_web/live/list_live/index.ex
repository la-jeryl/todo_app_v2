defmodule ClientWeb.ListLive.Index do
  use ClientWeb, :live_view

  alias Client.Lists
  alias Client.Lists.List

  @impl true
  def mount(_params, session, socket) do
    case Lists.list_lists(session["user_token"]) do
      {:ok, lists} ->
        {:ok,
         socket
         |> assign(:token, session["user_token"])
         |> assign(:user_id, session["current_user"]["id"])
         |> assign(:lists, lists)}

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

  defp apply_action(socket, :edit, %{"id" => id}) do
    with {:ok, todo_list} <- Lists.get_list(socket.assigns.token, id) do
      socket
      |> assign(:token, socket.assigns.token)
      |> assign(:user_id, socket.assigns.user_id)
      |> assign(:page_title, "Edit List")
      |> assign(:list, todo_list)
    end
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:token, socket.assigns.token)
    |> assign(:user_id, socket.assigns.user_id)
    |> assign(:page_title, "New List")
    |> assign(:list, %List{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:token, socket.assigns.token)
    |> assign(:user_id, socket.assigns.user_id)
    |> assign(:page_title, "Listing Lists")
    |> assign(:list, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    token = socket.assigns.token

    case Lists.delete_list(token, id) do
      {:ok, response} ->
        {:noreply,
         socket
         |> assign(:lists, list_lists(token))
         |> put_flash(:info, "#{response["message"]}")
         |> push_redirect(to: "/lists")}
    end
  end

  defp list_lists(token) do
    case Lists.list_lists(token) do
      {:ok, lists} ->
        lists

      {:error, reason} ->
        {:error, reason}
    end
  end
end
