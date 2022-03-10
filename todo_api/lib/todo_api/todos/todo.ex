defmodule TodoApi.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  alias TodoApi.Lists.List

  schema "todos" do
    field :description, :string
    field :is_done, :boolean, default: false
    field :priority, :integer
    belongs_to(:list, List)

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:priority, :description, :is_done])
    |> validate_required([:priority, :description, :is_done])
    |> assoc_constraint(:list)
  end
end
