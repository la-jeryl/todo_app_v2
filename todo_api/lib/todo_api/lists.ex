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

      iex> get_list_by_id(123)
      {:ok, %List{}}

      iex> get_list_by_id(456)
      {:not_found, "Todo list not found"}

  """
  def get_list_by_id(id) do
    case List
         |> Repo.get(id)
         |> Repo.preload(:todos) do
      nil -> {:not_found, "Todo list not found"}
      list -> {:ok, list}
    end
  end

  @doc """
  Gets a single list based on priority number.

  ## Examples

      iex> get_list_by_id(123)
      {:ok, %List{}}

      iex> get_list_by_id(456)
      {:not_found, "Todo list not found"}

  """
  def get_list_by_priority(priority) do
    case List
         |> Repo.get_by(Todo, priority: priority)
         |> Repo.preload(:todos) do
      nil -> {:not_found, "Todo list not found"}
      list -> {:ok, list}
    end
  end

  @doc """
  Creates a list.

  ## Examples

      iex> create_list(%{field: value})
      {:ok, %List{}}

      iex> create_list(%{field: bad_value})
      {:error, "Cannot create the todo list"}

  """
  def create_list(attrs \\ %{}) do
    result =
      with true <- Map.has_key?(attrs, :priority),
           true <- Map.get(attrs, :priority) != nil do
        # check if proposed priority value is within valid range
        proposed_priority_value = Map.get(attrs, :priority)
        latest_todo_list_count = latest_todo_lists_count()

        if proposed_priority_value in 1..latest_todo_list_count do
          # Could return {:ok, struct} or {:error, changeset}
          inserted_todo_list =
            %List{}
            |> List.changeset(attrs)
            |> Repo.insert()
            |> case do
              {:ok, %List{} = list} -> {:ok, Repo.preload(list, :todos)}
              _ -> {:error, "Cannot create the todo list"}
            end

          {:ok, todo_list_details} = inserted_todo_list

          # move_todo does resetting of todo priorities
          move_list(todo_list_details, proposed_priority_value)

          inserted_todo_list
        else
          {:out_of_range, "Assigned 'priority' is out of valid range"}
        end
      else
        _ ->
          # update the todo priority based on the latest count
          updated_todo_list_map =
            Map.put(attrs, :priority, latest_todo_lists_count()) |> key_to_atom()

          %List{}
          |> List.changeset(updated_todo_list_map)
          |> Repo.insert()
          |> case do
            {:ok, %List{} = list} -> {:ok, Repo.preload(list, :todos)}
            _ -> {:error, "Cannot create the todo list"}
          end
      end

    # Could return {:ok, struct} or {:error, reason}
    case result do
      {:ok, result} -> {:ok, result}
      {:out_of_range, reason} -> {:error, reason}
      {:error, _} -> {:error, "Cannot create the todo list"}
    end
  end

  @doc """
  Updates a list.

  ## Examples

      iex> update_list(list, %{field: new_value})
      {:ok, %List{}}

      iex> update_list(list, %{field: bad_value})
      {:error, "Cannot update the todo list"}

  """
  def update_list(%List{} = list, attrs) do
    result =
      with {:ok, _list} <- get_list_by_id(list.id),
           true <- Map.has_key?(attrs, :priority),
           true <- Map.get(attrs, :priority) != nil do
        # check if proposed priority value is within valid range
        proposed_priority_value = Map.get(attrs, :priority)
        current_todo_lists_count = current_todo_lists_count()

        if proposed_priority_value in 1..current_todo_lists_count do
          # move_todo does resetting of todo priorities
          move_list(list, proposed_priority_value)

          # Could return {:ok, struct} or {:error, reason}
          list |> List.changeset(attrs) |> Repo.update()
        else
          {:out_of_range, "Assigned 'priority' is out of valid range"}
        end
      else
        _ -> list |> List.changeset(attrs) |> Repo.update()
      end

    # Could return {:ok, struct} or {:error, reason}
    case result do
      {:ok, result} -> {:ok, result}
      {:out_of_range, reason} -> {:error, reason}
      {:not_found, reason} -> {:error, reason}
      {:error, _} -> {:error, "Cannot update the todo list"}
    end
  end

  @doc """
  Updates a list based on priority number.

  ## Examples

      iex> update_list_by_priority(priority_number, %{field: new_value})
      {:ok, %List{}}

      iex> update_list_by_priority(priority_number, %{field: bad_value})
      {:error, "Cannot update the todo list"}

  """
  def update_list_by_priority(priority_number, attrs) do
    with {:ok, todo_list} <- get_list_by_priority(priority_number),
         {:ok, updated_todo_list} <- update_list(todo_list, attrs) do
      {:ok, updated_todo_list}
    else
      {:not_found, reason} -> {:error, reason}
      {:error, _} -> {:error, "Cannot update the todo"}
    end
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> delete_list(list)
      {:ok, %List{}}

      iex> delete_list(list)
      {:error, Cannot delete the todo list"}

  """
  def delete_list(%List{} = list) do
    with {:ok, list} <- get_list_by_id(list.id),
         {:ok, list} <- Repo.delete(list) do
      {:ok, "'#{list.list_name}' todo list is deleted"}
    else
      {:not_found, reason} -> {:error, reason}
      {:error, _reason} -> {:error, "Cannot delete the todo list"}
    end
  end

  @doc """
  Deletes a list based on priority number.

  ## Examples

      iex> delete_list(priority_number)
      {:ok, %List{}}

      iex> delete_list(priority_number)
      {:error, Cannot delete the todo list"}

  """
  def delete_list_by_priority(priority_number) do
    with {:ok, todo_list} <- get_list_by_priority(priority_number),
         {:ok, deleted_list} <- Repo.delete(todo_list) do
      {:ok, "'#{deleted_list.list_name}' todo list is deleted"}
    else
      {:not_found, reason} -> {:error, reason}
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

  ######################################################################

  defp key_to_atom(map) do
    Enum.reduce(map, %{}, fn
      # String.to_existing_atom saves us from overloading the VM by
      # creating too many atoms. It'll always succeed because all the fields
      # in the database already exist as atoms at runtime.
      {key, value}, acc when is_atom(key) -> Map.put(acc, key, value)
      {key, value}, acc when is_binary(key) -> Map.put(acc, String.to_existing_atom(key), value)
    end)
  end

  defp reset_list_priorities(todo_list_list) do
    todo_list_list
    |> Enum.with_index(1)
    |> Enum.map(fn {item, index} ->
      item
      |> List.changeset(%{priority: index})
      |> Repo.update()
    end)
  end

  defp move_list(%List{} = list, proposed_priority_value) do
    {:ok, todo_list_list} = list_lists()

    current_todo_list_index = todo_list_list |> Enum.find_index(&(&1.id == list.id))

    updated_todo_list_list =
      todo_list_list |> Enum.slide(current_todo_list_index, proposed_priority_value - 1)

    reset_list_priorities(updated_todo_list_list)
  end

  defp latest_todo_lists_count do
    current_todo_lists_count() + 1
  end

  defp current_todo_lists_count do
    from(item in List, select: count())
    |> Repo.one()
  end
end
