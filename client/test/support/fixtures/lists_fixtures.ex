defmodule Client.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Client.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        list_name: "some list_name",
        user_id: 42
      })
      |> Client.Lists.create_list()

    list
  end
end
