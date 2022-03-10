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
    rescue
      _ -> {:error, "Cannot get the list of todos"}
    end
  end

  @doc """
  Gets a single todo based on the id.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo(123)
      {:ok, %Todo{}}

      iex> get_todo(456)
      {:error, "Todo not found"}

  """
  def get_todo(id) do
    case Repo.get(Todo, id) do
      nil -> {:error, "Todo not found"}
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
    case list
         |> Ecto.build_assoc(:todos)
         |> Todo.changeset(attrs)
         |> Repo.insert() do
      {:ok, todo} ->
        {:ok, todo}

      {:error, _reason} ->
        {:error, "Cannot create the todo"}
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
    get_todo(todo.id)

    case todo
         |> Todo.changeset(attrs)
         |> Repo.update() do
      {:ok, todo} ->
        {:ok, todo}

      {:error, _reason} ->
        {:error, "Cannot update the todo"}
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
    get_todo(todo.id)

    case Repo.delete(todo) do
      {:ok, todo} -> {:ok, "'#{todo.description}' todo is deleted"}
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

  defp get_all_todos_raw do
    try do
      result =
        from(item in Todo, order_by: [asc: :priority])
        |> Repo.all()

      {:ok, result}
    catch
      error -> {:error, error}
    end
  end

  defp get_todo_by_priority_raw(priority_value) do
    try do
      result = Repo.get_by(Todo, priority: priority_value)

      with true <- result != nil do
        {:ok, result}
      else
        _ -> {:error, "Todo not found"}
      end
    catch
      error -> {:error, error}
    end
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
    {:ok, todo_list} = get_all_todos_raw()

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
