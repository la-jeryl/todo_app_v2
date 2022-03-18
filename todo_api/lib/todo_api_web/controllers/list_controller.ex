defmodule TodoApiWeb.ListController do
  use TodoApiWeb, :controller

  alias TodoApi.Lists
  alias TodoApi.Lists.List

  action_fallback TodoApiWeb.FallbackController

  def index(conn, _params) do
    with {:ok, lists} <- Lists.list_lists(),
         filtered_user_lists <- Enum.filter(lists, &(&1.user_id == conn.assigns.current_user.id)) do
      render(conn, "index.json", lists: filtered_user_lists)
    else
      {:error, reason} ->
        conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def create(conn, %{"list" => list_params}) do
    updated_params = Map.put(list_params, "user_id", conn.assigns.current_user.id)

    with {:ok, %List{} = list} <- Lists.create_list(updated_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.list_path(conn, :show, list))
      |> render("show.json", list: list)
    else
      {_, reason} ->
        conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, list} <- Lists.get_list_by_id(id),
         true <- list.id == conn.assigns.current_user.id do
      render(conn, "show.json", list: list)
    else
      false ->
        conn
        |> put_status(:bad_request)
        |> render("error.json",
          error: "Logged in user is not allowed to access a todo list from a different user"
        )

      {_, reason} ->
        conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    updated_params = Map.put(list_params, "user_id", conn.assigns.current_user.id)

    with {:ok, list} <- Lists.get_list_by_id(id),
         true <- list.user_id == conn.assigns.current_user.id,
         {:ok, %List{} = list} <- Lists.update_list(list, updated_params) do
      render(conn, "show.json", list: list)
    else
      false ->
        conn
        |> put_status(:bad_request)
        |> render("error.json",
          error: "Logged in user is not allowed to update a todo list from a different user"
        )

      {_, reason} ->
        conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, list} <- Lists.get_list_by_id(id),
         true <- list.user_id == conn.assigns.current_user.id,
         {:ok, _list} <- Lists.delete_list(list) do
      render(conn, "delete_list_with_todos.json",
        message: "'#{list.list_name}' todo list was deleted."
      )
    else
      false ->
        conn
        |> put_status(:bad_request)
        |> render("error.json",
          error: "Logged in user is not allowed to delete a todo list from a different user"
        )

      {_, reason} ->
        conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end
end
