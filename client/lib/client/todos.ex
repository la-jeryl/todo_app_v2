defmodule Client.Todos do
  use Tesla

  # plug Tesla.Middleware.BaseUrl, "http://localhost:4000/api"
  plug(Tesla.Middleware.BaseUrl, "192.168.64.2:4000/api")
  plug(Tesla.Middleware.JSON)

  alias Client.Helpers

  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  # alias Client.Repo

  # alias Client.Todos.List

  @doc """
  Returns the list of Todos.

  ## Examples

      iex> list_todos(token)
      [%Todo{}, ...]

  """
  def list_todos(token, list_id) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- get(client, "/lists/#{list_id}/todos/") do
      case Map.has_key?(response.body, "data") do
        true ->
          {:ok, Helpers.keys_to_atoms(response.body["data"])}

        false ->
          {:error, response.body["error"]}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Gets a single todo.

  ## Examples

      iex> get_todo(token,123,1)
      {:ok, %Todo{}}

      iex> get_todo(456)
      {:error, reason}

  """

  def get_todo(token, list_id, todo_id) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- get(client, "/lists/#{list_id}/todos/#{todo_id}") do
      case Map.has_key?(response.body, "data") do
        true ->
          {:ok, Helpers.keys_to_atoms(response.body["data"])}

        false ->
          {:error, response.body["error"]}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def get_todo_by_priority(token, list_id, priority_number) do
    with {:ok, response} <- list_todos(token, list_id) do
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
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(token, 1, %{todo: %{title: "testing", priority: 1, is_done: false, description: "testing the code"}})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, reason}

  """
  def create_todo(token, list_id, todo_body) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- post(client, "/lists/#{list_id}/todos/", todo_body) do
      case Map.has_key?(response.body, "data") do
        true ->
          {:ok, response.body["data"]}

        false ->
          {:error, response.body["error"]}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(token, 1, 5, %{todo: %{title: "testing", priority: 1, is_done: false, description: "testing the code"}})
      {:ok, %List{}}

      iex> update_todo(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(token, list_id, todo_id, todo_body) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- patch(client, "/lists/#{list_id}/todos/#{todo_id}", todo_body) do
      case Map.has_key?(response.body, "data") do
        true ->
          {:ok, response.body["data"]}

        false ->
          {:error, response.body["error"]}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def edit_todo_by_priority(token, list_id, priority_number, todo_body) do
    with todo <- get_todo_by_priority(token, list_id, priority_number) do
      case Map.has_key?(todo, "code") do
        true -> todo
        false -> update_todo(token, list_id, todo["id"], todo_body)
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_list(token, list_id, todo_id)
      {:ok, %Todo{}}

      iex> delete_list(list)
      {:error, reason}

  """
  def delete_todo(token, list_id, todo_id) do
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- delete(client, "/lists/#{list_id}/todos/#{todo_id}") do
      case Map.has_key?(response.body, "data") do
        true ->
          {:ok, response.body["data"]}

        false ->
          {:error, response.body["error"]}
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end

  def delete_todo_by_priority(token, list_id, priority_number) do
    with todo <- get_todo_by_priority(token, list_id, priority_number) do
      case Map.has_key?(todo, "code") do
        true -> todo
        false -> delete_todo(token, list_id, todo["id"])
      end
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
