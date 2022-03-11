defmodule TodoApi.TodosTest do
  use TodoApi.DataCase

  alias TodoApi.Todos

  describe "todos" do
    alias TodoApi.Todos.Todo

    import TodoApi.TodosFixtures
    import TodoApi.ListsFixtures

    @invalid_attrs %{description: nil, is_done: nil, priority: nil}
    @valid_attrs %{description: "some description", is_done: true, priority: 1}
    @out_of_range_attrs %{description: "some description", is_done: true, priority: 100}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == {:ok, [todo]}
    end

    test "get_todo_by_id/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo_by_id(todo.id) == {:ok, todo}
    end

    test "get_todo_by_priority/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo_by_priority(todo.priority) == {:ok, todo}
      assert todo.priority == 1
    end

    test "create_todo/1 with valid data creates a todo" do
      list = list_fixture()
      assert {:ok, %Todo{} = todo} = Todos.create_todo(list, @valid_attrs)
      assert todo.description == "some description"
      assert todo.is_done == true
      assert todo.priority == 1
    end

    test "create_todo/1 with invalid data returns error" do
      list = list_fixture()
      assert {:error, "Cannot create the todo"} = Todos.create_todo(list, @invalid_attrs)
    end

    test "create_todo/1 with invalid priority returns error" do
      list = list_fixture()

      assert {:error, "Assigned 'priority' is out of valid range"} =
               Todos.create_todo(list, @out_of_range_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{description: "some updated description", is_done: false}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.description == "some updated description"
      assert todo.is_done == false
    end

    test "update_todo/2 with invalid data returns error" do
      todo = todo_fixture()
      assert {:error, "Cannot update the todo"} = Todos.update_todo(todo, @invalid_attrs)
      assert {:ok, todo} == Todos.get_todo_by_id(todo.id)
    end

    test "update_todo/2 with invalid priority returns error" do
      todo = todo_fixture()

      assert {:error, "Assigned 'priority' is out of valid range"} =
               Todos.update_todo(todo, @out_of_range_attrs)

      assert {:ok, todo} == Todos.get_todo_by_id(todo.id)
    end

    test "update_todo_by_priority/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{description: "some updated description", is_done: false}

      assert {:ok, %Todo{} = todo} = Todos.update_todo_by_priority(todo.priority, update_attrs)
      assert todo.description == "some updated description"
      assert todo.is_done == false
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, "'some description' todo is deleted"} = Todos.delete_todo(todo)
      assert {:not_found, "Todo not found"} == Todos.get_todo_by_id(todo.id)
    end

    test "delete_todo_by_priority/1 deletes the todo by priority" do
      todo = todo_fixture()

      assert {:ok, "'some description' todo is deleted"} =
               Todos.delete_todo_by_priority(todo.priority)

      assert {:not_found, "Todo not found"} == Todos.get_todo_by_id(todo.id)
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
