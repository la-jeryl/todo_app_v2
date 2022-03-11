defmodule TodoApi.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo

  alias TodoApi.Todos.Todo
  alias TodoApi.Lists.List

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      {:ok, [%Todo{}, ...]}

      iex> list_todos()
      {:error, "Cannot get the list of todos"}

  """
  def list_todos do
    try do
      todos =
        from(item in Todo, order_by: [asc: :priority])
        |> Repo.all()

      {:ok, todos}
    catch
      _ -> {:error, "Cannot get the list of todos"}
    end
  end

  @doc """
  Gets a single todo based on the id.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo_by_id(123)
      {:ok, %Todo{}}

      iex> get_todo_by_id(456)
      {:error, "Todo not found"}

  """
  def get_todo_by_id(id) do
    case Repo.get(Todo, id) do
      nil -> {:not_found, "Todo not found"}
      todo -> {:ok, todo}
    end
  end

  @doc """
  Gets a single todo based on priority number.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo_by_priority(123)
      {:ok, %Todo{}}

      iex> get_todo_by_priority(456)
      {:error, "Todo not found"}

  """
  def get_todo_by_priority(priority) do
    case Repo.get_by(Todo, priority: priority) do
      nil -> {:not_found, "Todo not found"}
      todo -> {:ok, todo}
    end
  end

  @doc """
  Creates a todo in a list.

  ## Examples

      iex> create_todo(%List{}, %{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%List{}, %{field: bad_value})
      {:error, "Cannot create the todo"}

  """
  def create_todo(%List{} = list, attrs \\ %{}) do
    result =
      with true <- Map.has_key?(attrs, :priority),
           true <- Map.get(attrs, :priority) != nil do
        # check if proposed priority value is within valid range
        proposed_priority_value = Map.get(attrs, :priority)
        latest_todos_count = latest_todos_count()

        if proposed_priority_value in 1..latest_todos_count do
          # Could return {:ok, struct} or {:error, changeset}
          inserted_todo =
            list
            |> Ecto.build_assoc(:todos)
            |> Todo.changeset(attrs)
            |> Repo.insert()

          {:ok, todo_details} = inserted_todo

          # move_todo does resetting of todo priorities
          move_todo(todo_details, proposed_priority_value)

          inserted_todo
        else
          {:out_of_range, "Assigned 'priority' is out of valid range"}
        end
      else
        _ ->
          # update the todo priority based on the latest count
          updated_todo_map = Map.put(attrs, :priority, latest_todos_count()) |> key_to_atom()

          list
          |> Ecto.build_assoc(:todos)
          |> Todo.changeset(updated_todo_map)
          |> Repo.insert()
      end

    # Could return {:ok, struct} or {:error, changeset}
    case result do
      {:ok, result} -> {:ok, result}
      {:out_of_range, reason} -> {:error, reason}
      {:error, _} -> {:error, "Cannot create the todo"}
    end
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, "Cannot update the todo"}

  """
  def update_todo(%Todo{} = todo, attrs) do
    result =
      with true <- Map.has_key?(attrs, :priority),
           true <- Map.get(attrs, :priority) != nil do
        # check if proposed priority value is within valid range
        proposed_priority_value = Map.get(attrs, :priority)
        current_record_count = current_todos_count()

        if proposed_priority_value in 1..current_record_count do
          # move_todo does resetting of todo priorities
          move_todo(todo, proposed_priority_value)

          # Could return {:ok, struct} or {:error, changeset}
          todo |> Todo.changeset(attrs) |> Repo.update()
        else
          {:out_of_range, "Assigned 'priority' is out of valid range"}
        end
      else
        _ -> todo |> Todo.changeset(attrs) |> Repo.update()
      end

    # Could return {:ok, struct} or {:error, changeset}
    case result do
      {:ok, result} -> {:ok, result}
      {:out_of_range, reason} -> {:error, reason}
      {:not_found, reason} -> {:error, reason}
      {:error, _} -> {:error, "Cannot update the todo"}
    end
  end

  @doc """
  Updates a todo based on priority number.

  ## Examples

      iex> update_todo_by_priority(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo_by_priority(todo, %{field: bad_value})
      {:error, "Cannot update the todo"}

  """
  def update_todo_by_priority(priority_number, attrs) do
    with {:ok, todo} <- get_todo_by_priority(priority_number),
         {:ok, updated_todo} <- update_todo(todo, attrs) do
      {:ok, updated_todo}
    else
      {:not_found, reason} -> {:error, reason}
      {:error, _} -> {:error, "Cannot update the todo"}
    end
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, "Cannot delete the todo"}

  """
  def delete_todo(%Todo{} = todo) do
    with {:ok, todo} <- get_todo_by_id(todo.id),
         {:ok, deleted_todo} <- Repo.delete(todo) do
      {:ok, "'#{deleted_todo.description}' todo is deleted"}
    else
      {:not_found, reason} -> {:error, reason}
      {:error, _reason} -> {:error, "Cannot delete the todo"}
    end
  end

  @doc """
  Deletes a todo based on priority number.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, "Cannot delete the todo"}

  """
  def delete_todo_by_priority(priority_number) do
    with {:ok, todo} <- get_todo_by_priority(priority_number),
         {:ok, deleted_todo} <- Repo.delete(todo) do
      {:ok, "'#{deleted_todo.description}' todo is deleted"}
    else
      {:not_found, reason} -> {:error, reason}
      {:error, _reason} -> {:error, "Cannot delete the todo"}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
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

  defp reset_todos_priorities(todo_list) do
    todo_list
    |> Enum.with_index(1)
    |> Enum.map(fn {item, index} ->
      item
      |> Todo.changeset(%{priority: index})
      |> Repo.update()
    end)
  end

  defp move_todo(%Todo{} = todo, proposed_priority_value) do
    {:ok, todo_list} = list_todos()

    current_todo_index = todo_list |> Enum.find_index(&(&1.id == todo.id))

    updated_todo_list = todo_list |> Enum.slide(current_todo_index, proposed_priority_value - 1)

    reset_todos_priorities(updated_todo_list)
  end

  defp latest_todos_count do
    current_todos_count() + 1
  end

  defp current_todos_count do
    from(item in Todo, select: count())
    |> Repo.one()
  end
end
