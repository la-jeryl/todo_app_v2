defmodule TodoApiWeb.ListView do
  use TodoApiWeb, :view
  alias TodoApiWeb.ListView

  def render("index.json", %{lists: lists}) do
    %{data: render_many(lists, ListView, "list.json")}
  end

  def render("show.json", %{list: list}) do
    %{data: render_one(list, ListView, "list.json")}
  end

  def render("list.json", %{list: list}) do
    %{
      id: list.id,
      user_id: list.user_id,
      list_name: list.list_name
    }
  end
end
