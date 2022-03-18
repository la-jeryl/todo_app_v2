defmodule Client.Todos do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://localhost:4000/api"
  plug Tesla.Middleware.JSON

  alias Client.Todos.Todo

  def get_all_todos(token, list_id) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- get(client, "/lists/#{list_id}/todos/") do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def get_todo(token, list_id, todo_id) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- get(client, "/lists/#{list_id}/todos/#{todo_id}") do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def get_todo_by_priority(token, list_id, priority_number) do
    with response <- get_all_todos(token, list_id) do
      case is_map(response) do
        true ->
          response

        false ->
          case Enum.find(response, &(&1["priority"] == priority_number)) do
            nil -> %{"error" => "Todo not found"}
            todo -> todo
          end
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def new_todo(token, list_id, %Todo{} = todo_body) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- post(client, "/lists/#{list_id}/todos/", todo_body) do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def edit_todo(token, list_id, todo_id, %Todo{} = todo_body) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- patch(client, "/lists/#{list_id}/todos/#{todo_id}", todo_body) do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def edit_todo_by_priority(token, list_id, priority_number, %Todo{} = todo_body) do
    with todo <- get_todo_by_priority(token, list_id, priority_number) do
      case Map.has_key?(todo, "code") do
        true -> todo
        false -> edit_todo(token, list_id, todo["id"], todo_body)
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def delete_todo(token, list_id, todo_id) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- delete(client, "/lists/#{list_id}/todos/#{todo_id}") do
      case Map.has_key?(response.body, "data") do
        true ->
          response.body["data"]

        false ->
          response.body["error"]
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end

  def delete_todo_by_priority(token, list_id, priority_number) do
    with todo <- get_todo_by_priority(token, list_id, priority_number) do
      case Map.has_key?(todo, "code") do
        true -> todo
        false -> delete_todo(token, list_id, todo["id"])
      end
    else
      {:error, reason} -> %{"error" => reason}
    end
  end
end
