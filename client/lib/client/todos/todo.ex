defmodule Client.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Client.Lists.List

  schema "todos" do
    field :title, :string
    field :description, :string
    field :is_done, :boolean, default: false
    field :priority, :integer
    # belongs_to(:list, List)

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:priority, :title, :description, :is_done])
    |> validate_required([:title, :is_done])

    # |> assoc_constraint(:list)
  end
end
