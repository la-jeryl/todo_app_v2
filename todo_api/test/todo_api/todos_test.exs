defmodule TodoApi.TodosTest do
  use TodoApi.DataCase

  alias TodoApi.Todos

  describe "todos" do
    alias TodoApi.Todos.Todo

    import TodoApi.TodosFixtures
    import TodoApi.ListsFixtures

    @invalid_attrs %{description: nil, is_done: nil, priority: nil}
    @valid_attrs %{description: "some description", is_done: true, priority: 42}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == {:ok, [todo]}
    end

    test "get_todo/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo(todo.id) == {:ok, todo}
    end

    test "create_todo/1 with valid data creates a todo" do
      list = list_fixture()
      assert {:ok, %Todo{} = todo} = Todos.create_todo(list, @valid_attrs)
      assert todo.description == "some description"
      assert todo.is_done == true
      assert todo.priority == 42
    end

    test "create_todo/1 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, "Cannot create the todo"} = Todos.create_todo(list, @invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{description: "some updated description", is_done: false, priority: 43}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.description == "some updated description"
      assert todo.is_done == false
      assert todo.priority == 43
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, "Cannot update the todo"} = Todos.update_todo(todo, @invalid_attrs)
      assert {:ok, todo} == Todos.get_todo(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, "'some description' todo is deleted"} = Todos.delete_todo(todo)
      assert {:error, "Todo not found"} == Todos.get_todo(todo.id)
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
