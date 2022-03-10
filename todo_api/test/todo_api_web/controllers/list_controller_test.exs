defmodule TodoApiWeb.ListControllerTest do
  use TodoApiWeb.ConnCase

  import TodoApi.ListsFixtures

  alias TodoApi.Lists.List

  @create_attrs %{
    list_name: "some list_name",
    user_id: 42
  }
  @update_attrs %{
    list_name: "some updated list_name",
    user_id: 43
  }
  @invalid_attrs %{list_name: nil, user_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all lists", %{conn: conn} do
      conn = get(conn, Routes.list_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create list" do
    test "renders list when data is valid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), list: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.list_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "list_name" => "some list_name",
               "user_id" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), list: @invalid_attrs)
      assert json_response(conn, 400) == %{"error" => "Cannot create the todo list"}
    end
  end

  describe "update list" do
    setup [:create_list]

    test "renders list when data is valid", %{conn: conn, list: %List{id: id} = list} do
      conn = put(conn, Routes.list_path(conn, :update, list), list: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.list_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "list_name" => "some updated list_name",
               "user_id" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, list: list} do
      conn = put(conn, Routes.list_path(conn, :update, list), list: @invalid_attrs)
      assert json_response(conn, 400) == %{"error" => "Cannot update the list"}
    end
  end

  describe "delete list" do
    setup [:create_list]

    test "deletes chosen list", %{conn: conn, list: list} do
      conn = delete(conn, Routes.list_path(conn, :delete, list))
      assert response(conn, 200)

      get_conn = get(conn, Routes.list_path(conn, :show, list))
      assert json_response(get_conn, 400) == %{"error" => "Todo list not found"}
    end
  end

  defp create_list(_) do
    list = list_fixture()
    %{list: list}
  end
end
