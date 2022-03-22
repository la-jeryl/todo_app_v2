defmodule Client.Lists do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://localhost:4000/api"
  plug Tesla.Middleware.JSON

  alias Client.Helpers

  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  # alias Client.Repo

  # alias Client.Lists.List

  @doc """
  Returns the list of lists.

  ## Examples

      iex> list_lists(token)
      [%List{}, ...]

  """
  def list_lists(token) do
    # Repo.all(List)
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- get(client, "/lists/") do
      case Map.has_key?(response.body, "data") do
        true ->
          {:ok, Helpers.keys_to_atoms(response.body["data"])}

        false ->
          {:error, response.body["error"]}
      end
    else
      reason -> {:error, reason}
    end
  end

  @doc """
  Gets a single list.

  ## Examples

      iex> get_list(token,123)
      %List{}

      iex> get_list!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_list!(id), do: Repo.get!(List, id)

  def get_list(token, list_id) do
    with {:ok, response} <- list_lists(token),
         todo_list <- Enum.find(response, &(&1.id == list_id |> String.to_integer())) do
      {:ok, todo_list}
    else
      reason -> {:error, reason}
    end
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(token, %{list: %{list_name: "working while on red bull", user_id: 1}})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(token, attrs \\ %{}) do
    # %List{}
    # |> List.changeset(attrs)
    # |> Repo.insert()

    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- post(client, "/lists", attrs) do
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
  Updates a list.

  ## Examples

      iex> update_list(token, list_id, %{list: %{list_name: "working while on red bull", user_id: 1}})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_list(token, list_id, list_body) do
    # list
    # |> List.changeset(attrs)
    # |> Repo.update()
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- patch(client, "/lists/#{list_id}", list_body) do
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
  Deletes a list.

  ## Examples

      iex> delete_list(token, list_id)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(token, list_id) do
    # Repo.delete(list)
    client = Tesla.client([{Tesla.Middleware.Headers, [{"authorization", token}]}])

    with {:ok, response} <- delete(client, "/lists/#{list_id}") do
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
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  # def change_list(%List{} = list, attrs \\ %{}) do
  #   List.changeset(list, attrs)
  # end
end
