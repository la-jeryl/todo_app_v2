defmodule TodoApiWeb.ListController do
  use TodoApiWeb, :controller

  alias TodoApi.Lists
  alias TodoApi.Lists.List

  action_fallback TodoApiWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    with {:ok, lists} <- Lists.list_lists(),
         true <- lists != [],
         filtered_list <- Enum.filter(lists, &(&1.user_id == user_id)) do
      render(conn, "index.json", lists: filtered_list)
    else
      false ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", error: "Cannot get the list of todo lists")

      {:error, reason} ->
        conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def create(conn, %{"list" => list_params}) do
    with {:ok, %List{} = list} <- Lists.create_list(list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.list_path(conn, :show, list))
      |> render("show.json", list: list)
    else
      {_, reason} -> conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, list} <- Lists.get_list_by_id(id) do
      render(conn, "show.json", list: list)
    else
      {_, reason} -> conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def update(conn, %{"id" => id, "list" => list_params}) do
    with {:ok, list} <- Lists.get_list_by_id(id),
         {:ok, %List{} = list} <- Lists.update_list(list, list_params) do
      render(conn, "show.json", list: list)
    else
      {_, reason} -> conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, list} <- Lists.get_list_by_id(id),
         {:ok, _list} <- Lists.delete_list(list) do
      render(conn, "delete_list_with_todos.json",
        message: "'#{list.list_name}' todo list was deleted."
      )
    else
      {_, reason} -> conn |> put_status(:bad_request) |> render("error.json", error: reason)
    end
  end
end
