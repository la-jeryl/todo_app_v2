defmodule TodoApi.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApi.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        list_name: "some list_name",
        user_id: 42
      })
      |> TodoApi.Lists.create_list()

    params =
      attrs
      |> Enum.into(%{
        description: "some description",
        is_done: true,
        priority: 1
      })

    {:ok, todo} = TodoApi.Todos.create_todo(list, params)

    todo
  end
end
