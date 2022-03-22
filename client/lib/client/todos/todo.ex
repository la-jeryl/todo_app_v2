defmodule Client.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :title, :string
    field :description, :string
    field :is_done, :boolean, default: false
    field :priority, :integer

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:priority, :title, :description, :is_done])
    |> validate_required([:title, :is_done])
  end
end
