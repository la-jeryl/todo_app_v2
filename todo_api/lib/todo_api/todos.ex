defmodule TodoApi.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias TodoApi.Repo

  alias TodoApi.Todos.Todo
  alias TodoApi.Lists.List
  alias TodoApi.Lists

  @doc """
  Returns the list of todos inside a todo list.

  ## Examples

      iex> list_todos(list_id)
      {:ok, [%Todo{}, ...]}

      iex> list_todos()
      {:error, "Cannot get the list of todos"}

  """
  def list_todos(%List{} = list) do
    with {:ok, todo_list} <- Lists.get_list_by_id(list.id),
         sorted_list <- Enum.sort_by(todo_list.todos, & &1.priority, :asc) do
      {:ok, sorted_list}
    else
      _ -> {:error, "Cannot get the list of todos"}
    end
  end

  @doc """
  Gets a single todo based on the id.

  ## Examples

      iex> get_todo_by_id(%List{}, 123)
      {:ok, %Todo{}}

      iex> get_todo_by_id(%List{}, 456)
      {:not_found, "Todo not found"}

  """
  def get_todo_by_id(%List{} = list, todo_id) do
    with todo <- Enum.find(list.todos, &(&1.id |> to_string() == todo_id)),
         true <- todo != nil do
      {:ok, todo}
    else
      _ -> {:not_found, "Todo not found"}
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
      with true <- Map.has_key?(attrs, "priority"),
           proposed_priority_value <- Map.get(attrs, "priority"),
           true <- proposed_priority_value != nil do
        # check if proposed priority value is within valid range
        latest_todos_count = Enum.count(list.todos) + 1

        if proposed_priority_value in 1..latest_todos_count do
          inserted_todo =
            list
            |> Ecto.build_assoc(:todos)
            |> Todo.changeset(attrs)
            |> Repo.insert()

          {:ok, todo_details} = inserted_todo

          if proposed_priority_value < latest_todos_count do
            arrange_todos(list, todo_details, proposed_priority_value, "create")
          end

          inserted_todo
        else
          {:out_of_range, "Assigned 'priority' is out of valid range"}
        end
      else
        _ ->
          # update the todo priority based on the latest count
          updated_todo_map = Map.put(attrs, :priority, Enum.count(list.todos) + 1)

          list
          |> Ecto.build_assoc(:todos)
          |> Todo.changeset(updated_todo_map)
          |> Repo.insert()
      end

    # Could return {:ok, struct} or {:error, changeset}
    case result do
      {:ok, result} ->
        {:ok, result}

      {:out_of_range, reason} ->
        {:error, reason}

      {:error, _} ->
        {:error, "Cannot create the todo"}
    end
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(%List{}, todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(%List{}, todo, %{field: bad_value})
      {:error, "Cannot update the todo"}

  """
  def update_todo(%List{} = list, %Todo{} = todo, attrs) do
    result =
      with true <- Map.has_key?(attrs, "priority"),
           proposed_priority_value <- Map.get(attrs, "priority"),
           true <- proposed_priority_value != nil do
        # check if proposed priority value is within valid range
        if proposed_priority_value in 1..Enum.count(list.todos) do
          arrange_todos(list, todo, proposed_priority_value, "update")

          todo |> Todo.changeset(attrs) |> Repo.update()
        else
          {:out_of_range, "Assigned 'priority' is out of valid range"}
        end
      else
        _ -> todo |> Todo.changeset(attrs) |> Repo.update()
      end

    case result do
      {:ok, result} -> {:ok, result}
      {:out_of_range, reason} -> {:error, reason}
      {:error, _} -> {:error, "Cannot update the todo"}
    end
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(%List{}, todo)
      {:ok, %Todo{}}

      iex> delete_todo(%List{}, todo)
      {:error, "Cannot delete the todo"}

  """
  def delete_todo(%List{} = list, %Todo{} = todo) do
    with {:ok, deleted_todo} <- Repo.delete(todo) do
      arrange_todos(list, todo, nil, "delete")
      {:ok, "'#{deleted_todo.title}' todo is deleted"}
    else
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

  defp arrange_todos(%List{} = todo_list, %Todo{} = todo, proposed_priority_value, action_type) do
    case action_type do
      "create" ->
        todo_list.todos
        |> Enum.sort_by(& &1.priority, :asc)
        |> custom_sort(proposed_priority_value)

      "update" ->
        Enum.filter(todo_list.todos, &(&1.id != todo.id))
        |> Enum.sort_by(& &1.priority, :asc)
        |> custom_sort(proposed_priority_value)

      "delete" ->
        Enum.filter(todo_list.todos, &(&1.id != todo.id))
        |> Enum.sort_by(& &1.priority, :asc)
        |> reset_todo_priorities()
    end
  end

  defp custom_sort(sorted_todo_list, proposed_priority_value) do
    # split the todo_list based on the item to be replaced
    first_half = Enum.split(sorted_todo_list, proposed_priority_value - 1) |> elem(0)
    second_half = Enum.split(sorted_todo_list, proposed_priority_value - 1) |> elem(1)

    # update the priorities on the second half starting on index 1
    reset_todo_priorities(first_half)

    # update the priorities on the second half starting on the proposed_priority_value + 1
    reset_todo_priorities(second_half, proposed_priority_value + 1)
  end

  defp reset_todo_priorities(todo_list, custom_index \\ 1) do
    todo_list
    |> Enum.with_index(custom_index)
    |> Enum.map(fn {item, index} ->
      item
      |> Todo.changeset(%{priority: index})
      |> Repo.update()
    end)
  end
end
