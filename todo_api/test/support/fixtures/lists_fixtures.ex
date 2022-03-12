defmodule TodoApi.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TodoApi.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        list_name: "some list_name",
        user_id: 1
      })
      |> TodoApi.Lists.create_list()

    list
  end
end
