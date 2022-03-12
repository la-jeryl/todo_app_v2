defmodule TodoClient.TodoList do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://localhost:4000/api"
  plug Tesla.Middleware.JSON

  @doc """
  Returns all of the todo lists.

  ## Examples

      iex> TodoClient.TodoList.get_all_lists
      %{
        "data" => [
          %{
            "id" => 3,
            "list_name" => "updating the first list",
            "todos" => [],
            "user_id" => 1
          },
          %{"id" => 8, "list_name" => "another list", "todos" => [], "user_id" => 1}
        ]
      }
  """
  def get_all_lists do
    with {_, response} <- get("/lists/") do
      response.body
    else
      _ -> %{"error" => "Cannot delete list"}
    end
  end

  @doc """
  Returns the details of a single todo list.

  ## Examples

      iex> TodoClient.TodoList.get_list(3)
      %{
        "data" => %{
          "id" => 3,
          "list_name" => "updating the first list",
          "todos" => [],
          "user_id" => 1
        }
      }
  """
  def get_list(list_id) do
    with {_, response} <- get("/lists/#{list_id |> Integer.to_string()}") do
      response.body
    else
      _ -> %{"error" => "Cannot get list"}
    end
  end

  @doc """
  Creates a new list.

  ## Examples

      iex> TodoClient.TodoList.new_list(%{ list: %{list_name: "my list", user_id: 1}})
      %{
        "data" => %{
          "id" => 10,
          "list_name" => "my list",
          "todos" => [],
          "user_id" => 1
        }
      }
  """
  def new_list(list_body) do
    with {_, response} <- post("/lists", list_body) do
      response.body
    else
      _ -> %{"error" => "Cannot create list"}
    end
  end

  @doc """
  Edits a list.

  ## Examples

      iex> TodoClient.TodoList.edit_list(8, %{list: %{list_name: "updated list"}})
      %{
        "data" => %{
          "id" => 8,
          "list_name" => "updated list",
          "todos" => [],
          "user_id" => 1
        }
      }
  """
  def edit_list(list_id, list_body) do
    with {_, response} <- patch("/lists/#{list_id |> Integer.to_string()}", list_body) do
      response.body
    else
      _ -> %{"error" => "Cannot edit list"}
    end
  end

  @doc """
  Deletes a list.

  ## Examples

      iex> TodoClient.TodoList.delete_list(7)
      %{"message" => "'another list' todo list was deleted."}
  """
  def delete_list(list_id) do
    with {_, response} <- delete("/lists/#{list_id |> Integer.to_string()}") do
      response.body
    else
      _ -> %{"error" => "Cannot delete list"}
    end
  end

  @doc """
  Returns all todos inside a todo list.

  ## Examples

      iex> TodoClient.TodoList.get_all_todos(5)
     %{
        "data" => [
          %{
            "description" => "first todo",
            "id" => 8,
            "is_done" => false,
            "priority" => 1
          },
          %{
            "description" => "second todo",
            "id" => 9,
            "is_done" => false,
            "priority" => 2
          }
        ]
      }
  """
  def get_all_todos(list_id) do
    with {_, response} <-
           get(
             "/lists/#{list_id |> Integer.to_string()}" <>
               "/todos/"
           ) do
      response.body
    else
      _ -> %{"error" => "Cannot get all todos"}
    end
  end

  @doc """
  Returns a single todo inside a todo list.

  ## Examples

      iex> TodoClient.TodoList.get_todo(9, 7)
      %{
        "data" => %{
          "description" => "second todo",
          "id" => 9,
          "is_done" => false,
          "priority" => 2
        }
      }
  """
  def get_todo(list_id, todo_id) do
    with {_, response} <-
           get(
             "/lists/#{list_id |> Integer.to_string()}" <>
               "/todos/#{todo_id |> Integer.to_string()}"
           ) do
      response.body
    else
      _ -> %{"error" => "Cannot get todo"}
    end
  end

  @doc """
  Returns a single todo inside a todo list based on priority

  ## Examples

      iex> TodoClient.TodoList.get_todo_by_priority(9, 2)
      %{
        "data" => %{
          "description" => "second todo",
          "id" => 9,
          "is_done" => false,
          "priority" => 2
        }
      }
  """
  def get_todo_by_priority(list_id, priority_number) do
    # with {_, response} <-
    #        get(
    #          "/lists/#{list_id |> Integer.to_string()}" <>
    #            "/todos/#{todo_id |> Integer.to_string()}"
    #        ) do
    #   response.body
    # else
    #   _ -> %{"error" => "Cannot get todo"}
    # end

    with todos <- get_all_todos(list_id),
         todo <- Enum.find(todos["data"], &(&1["priority"] == priority_number)) do
      response =
        case todo do
          nil -> %{"error" => "Todo not found"}
          _ -> todo
        end

      response
    else
      _ -> %{"error" => "Cannot find todo"}
    end
  end

  @doc """
  Creates a new todo inside a list.

  ## Examples

      iex> TodoClient.TodoList.new_todo(9, %{ todo: %{description: "my todo" }})
      %{
        "data" => %{
          "description" => "my todo",
          "id" => 10,
          "is_done" => false,
          "priority" => 3
        }
      }
  """
  def new_todo(list_id, todo_body) do
    with {_, response} <-
           post(
             "/lists/#{list_id |> Integer.to_string()}" <>
               "/todos/",
             todo_body
           ) do
      response.body
    else
      _ -> %{"error" => "Cannot create todo"}
    end
  end

  @doc """
  Edits a todo inside a list.

  ## Examples

      iex> TodoClient.TodoList.edit_todo(9, 7, %{todo: %{description: "updated todo"}})
      %{
        "data" => %{
          "description" => "updated todo",
          "id" => 11,
          "is_done" => false,
          "priority" => 4
        }
      }
  """
  def edit_todo(list_id, todo_id, todo_body) do
    with {_, response} <-
           patch(
             "/lists/#{list_id |> Integer.to_string()}" <>
               "/todos/#{todo_id |> Integer.to_string()}",
             todo_body
           ) do
      response.body
    else
      _ -> %{"error" => "Cannot edit todo"}
    end
  end

  @doc """
  Edits a todo inside a list based on priority number.

  ## Examples

      iex> TodoClient.TodoList.edit_todo_by_priority(9, 7, %{todo: %{description: "updated todo"}})
      %{
        "data" => %{
          "description" => "updated todo",
          "id" => 11,
          "is_done" => false,
          "priority" => 4
        }
      }
  """
  def edit_todo_by_priority(list_id, priority_number, todo_body) do
    with todos <- get_all_todos(list_id),
         todo <- Enum.find(todos["data"], &(&1["priority"] == priority_number)) do
      response =
        case todo do
          nil -> %{"error" => "Todo not found"}
          _ -> edit_todo(list_id, todo["id"], todo_body)
        end

      response
    else
      _ -> %{"error" => "Cannot edit todo"}
    end
  end

  @doc """
  Deletes a todo inside a list.

  ## Examples

      iex> TodoClient.TodoList.edit_todo(9, 7)
      %{"message" => "'do exercise' todo was deleted."}
  """
  def delete_todo(list_id, todo_id) do
    with {_, response} <-
           delete(
             "/lists/#{list_id |> Integer.to_string()}" <>
               "/todos/#{todo_id |> Integer.to_string()}"
           ) do
      response.body
    else
      _ -> %{"error" => "Cannot delete todo"}
    end
  end

  @doc """
  Deletes a todo inside a list based on priority number.

  ## Examples

      iex> TodoClient.TodoList.delete_todo_by_priority(9, 7)
      %{"message" => "'do exercise' todo was deleted."}
  """
  def delete_todo_by_priority(list_id, priority_number) do
    with todos <- get_all_todos(list_id),
         todo <- Enum.find(todos["data"], &(&1["priority"] == priority_number)) do
      response =
        case todo do
          nil -> %{"error" => "Todo not found"}
          _ -> delete_todo(list_id, todo["id"])
        end

      response
    else
      _ -> %{"error" => "Cannot delete todo"}
    end
  end
end
