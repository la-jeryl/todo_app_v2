defmodule ClientWeb.ListLive.Show do
  use ClientWeb, :live_view

  alias Client.Lists

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:token, session["user_token"])
      |> assign(:user_id, session["current_user"]["id"])

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    with {:ok, todo_list} <- Lists.get_list(socket.assigns.token, id) do
      {:noreply,
       socket
       |> assign(:user_id, socket.assigns.user_id)
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:list, todo_list)}
    end
  end

  defp page_title(:show), do: "Show List"
  defp page_title(:edit), do: "Edit List"
end
