defmodule TodoApi.Lists do
  @moduledoc """
  The Lists context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo

  alias TodoApi.Lists.List

  @doc """
  Returns the list of todo lists.

  ## Examples

      iex> list_lists()
      {:ok, [%List{}, ...]}

      iex> list_lists()
      {:error, "Cannot get the list of todo lists"}
  """
  def list_lists do
    try do
      lists =
        List
        |> Repo.all()
        |> Repo.preload(:todos)

      {:ok, lists}
    catch
      _ -> {:error, "Cannot get the list of todo lists"}
    end
  end

  @doc """
  Gets a single list based on the id.

  ## Examples

      iex> get_list(123)
      {:ok, %List{}}

      iex> get_list!(456)
      {:error, "Todo list not found"}

  """
  def get_list(id) do
    case List
         |> Repo.get(id)
         |> Repo.preload(:todos) do
      nil -> {:error, "Todo list not found"}
      list -> {:ok, list}
    end
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_list(attrs \\ %{}) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %List{} = list} -> {:ok, Repo.preload(list, :todos)}
      _ -> {:error, "Cannot create the todo list"}
    end
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, "Cannot update the list"}

  """
  def update_list(%List{} = list, attrs) do
    get_list(list.id)

    case list
         |> List.changeset(attrs)
         |> Repo.update() do
      {:ok, list} ->
        {:ok, list}

      {:error, _reason} ->
        {:error, "Cannot update the list"}
    end
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, %Ecto.Changeset{}}

  """
  def delete_list(%List{} = list) do
    get_list(list.id)

    case Repo.delete(list) do
      {:ok, list} -> {:ok, "'#{list.list_name}' todo list is deleted"}
      {:error, _reason} -> {:error, "Cannot delete the todo list"}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking list changes.

  ## Examples

      iex> change_list(list)
      %Ecto.Changeset{data: %List{}}

  """
  def change_list(%List{} = list, attrs \\ %{}) do
    List.changeset(list, attrs)
  end
end
