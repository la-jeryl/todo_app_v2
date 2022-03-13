defmodule TodoApiWeb.TodoControllerTest do
  use TodoApiWeb.ConnCase

  import TodoApi.TodosFixtures
  import TodoApi.ListsFixtures

  alias TodoApi.Lists
  alias TodoApi.Todos.Todo

  @create_attrs %{
    "title" => "some title",
    "is_done" => true,
    "priority" => 1
  }
  @update_attrs %{
    "title" => "some title",
    "is_done" => false,
    "priority" => 1
  }
  @invalid_attrs %{description: nil, is_done: nil, priority: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all todos from a list", %{conn: conn} do
      conn = get(conn, Routes.list_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo" do
    test "renders todo when data is valid", %{conn: conn} do
      list = list_fixture()
      conn = post(conn, Routes.list_todo_path(conn, :create, list.id), todo: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.list_todo_path(conn, :show, list.id, id))

      assert %{
               "id" => ^id,
               "title" => "some title",
               "is_done" => true,
               "priority" => 1
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      list = list_fixture()
      conn = post(conn, Routes.list_todo_path(conn, :create, list.id), todo: @invalid_attrs)
      assert json_response(conn, 400) == %{"error" => "Cannot create the todo"}
    end
  end

  describe "update todo" do
    setup [:create_todo]

    test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: _id} = _todo} do
      list = list_fixture()
      _todo = todo_fixture(list)
      {:ok, updated_list} = Lists.get_list_by_id(list.id)
      todo_id = List.first(updated_list.todos, 1).id

      conn =
        put(
          conn,
          Routes.list_todo_path(conn, :update, list.id, todo_id),
          todo: @update_attrs
        )

      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.list_todo_path(conn, :show, list.id, id))

      assert %{
               "id" => _id,
               "title" => "some title",
               "description" => nil,
               "is_done" => false,
               "priority" => 1
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: _todo} do
      list = list_fixture()
      todo = todo_fixture(list)

      conn =
        put(conn, Routes.list_todo_path(conn, :update, list.id, todo.id), todo: @invalid_attrs)

      assert json_response(conn, 400) == %{"error" => "Cannot update the todo"}
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    test "deletes chosen todo", %{conn: conn, todo: _todo} do
      list = list_fixture()
      todo = todo_fixture(list)
      conn = delete(conn, Routes.list_todo_path(conn, :delete, list.id, todo.id))
      assert json_response(conn, 200) == %{"message" => "'some title' todo was deleted."}

      get_conn = get(conn, Routes.list_todo_path(conn, :show, list.id, todo.id))
      assert json_response(get_conn, 400) == %{"error" => "Todo not found"}
    end
  end

  defp create_todo(_) do
    list = list_fixture()
    todo = todo_fixture(list)
    %{todo: todo}
  end
end
