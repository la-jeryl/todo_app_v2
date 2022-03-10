defmodule TodoApi.ListsTest do
  use TodoApi.DataCase

  alias TodoApi.Lists

  describe "lists" do
    alias TodoApi.Lists.List

    import TodoApi.ListsFixtures

    @invalid_attrs %{list_name: nil, user_id: nil}
    @valid_attrs %{list_name: "some list_name", user_id: 42}

    test "list_lists/0 returns all lists" do
      list = list_fixture()
      assert Lists.list_lists() == {:ok, [list]}
    end

    test "get_list/1 returns the list with given id" do
      list = list_fixture()
      assert Lists.get_list(list.id) == {:ok, list}
    end

    test "get_list/1 returns an error when not found" do
      # 1 is just a random number. No list was created on this test.
      assert {:error, "Todo list not found"} == Lists.get_list(1)
    end

    test "create_list/1 with valid data creates a list" do
      assert {:ok, %List{} = list} = Lists.create_list(@valid_attrs)
      assert list.list_name == "some list_name"
      assert list.user_id == 42
    end

    test "create_list/1 with invalid data returns error message" do
      assert {:error, "Cannot create the todo list"} = Lists.create_list(@invalid_attrs)
    end

    test "update_list/2 with valid data updates the list" do
      list = list_fixture()
      update_attrs = %{list_name: "some updated list_name", user_id: 43}

      assert {:ok, %List{} = list} = Lists.update_list(list, update_attrs)
      assert list.list_name == "some updated list_name"
      assert list.user_id == 43
    end

    test "update_list/2 with invalid data returns error changeset" do
      list = list_fixture()
      assert {:error, "Cannot update the list"} = Lists.update_list(list, @invalid_attrs)
      assert {:ok, list} == Lists.get_list(list.id)
    end

    test "delete_list/1 deletes the list" do
      list = list_fixture()
      assert {:ok, "'some list_name' todo list is deleted"} = Lists.delete_list(list)
      assert {:error, "Todo list not found"} == Lists.get_list(list.id)
    end

    test "change_list/1 returns a list changeset" do
      list = list_fixture()
      assert %Ecto.Changeset{} = Lists.change_list(list)
    end
  end
end
