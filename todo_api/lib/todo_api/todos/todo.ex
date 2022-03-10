defmodule TodoApi.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :description, :string
    field :is_done, :boolean, default: false
    field :priority, :integer
    field :list_id, :id

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:priority, :description, :is_done])
    |> validate_required([:priority, :description, :is_done])
  end
end
