defmodule TodoApi.TodosTest do
  use TodoApi.DataCase

  alias TodoApi.Todos
  alias TodoApi.Lists

  describe "todos" do
    alias TodoApi.Todos.Todo

    import TodoApi.TodosFixtures
    import TodoApi.ListsFixtures

    @invalid_attrs %{"description" => nil, "is_done" => nil, "priority" => nil}
    @valid_attrs %{"description" => "some description", "is_done" => true, "priority" => 1}
    @out_of_range_attrs %{
      "description" => "some description",
      "is_done" => true,
      "priority" => 100
    }

    test "list_todos/0 returns all todos" do
      list = list_fixture()
      todo = todo_fixture(list)
      assert Todos.list_todos(list) == {:ok, [todo]}
    end

    test "get_todo_by_id/1 returns the todo with given id" do
      list = list_fixture()
      todo = todo_fixture(list)
      {:ok, updated_list} = Lists.get_list_by_id(list.id)
      assert List.first(updated_list.todos, 1) == todo
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
      list = list_fixture()
      todo = todo_fixture(list)
      update_attrs = %{description: "some updated description", is_done: false}

      assert {:ok, %Todo{} = todo} = Todos.update_todo(list, todo, update_attrs)
      assert todo.description == "some updated description"
      assert todo.is_done == false
    end

    test "update_todo/2 with invalid data returns error" do
      list = list_fixture()
      todo = todo_fixture(list)
      assert {:error, "Cannot update the todo"} = Todos.update_todo(list, todo, @invalid_attrs)
    end

    test "update_todo/2 with invalid priority returns error" do
      list = list_fixture()
      todo = todo_fixture(list)

      assert {:error, "Assigned 'priority' is out of valid range"} ==
               Todos.update_todo(list, todo, @out_of_range_attrs)
    end

    test "delete_todo/1 deletes the todo" do
      list = list_fixture()
      todo = todo_fixture(list)

      assert {:ok, "'some description' todo is deleted"} = Todos.delete_todo(list, todo)
      assert {:not_found, "Todo not found"} == Todos.get_todo_by_id(list, todo.id)
    end

    test "change_todo/1 returns a todo changeset" do
      list = list_fixture()
      todo = todo_fixture(list)
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
