defmodule Client.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Client.Todos.Todo

  schema "lists" do
    field :list_name, :string
    field :user_id, :integer
    # has_many(:todos, Todo, on_replace: :delete)

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:user_id, :list_name])
    # |> cast_assoc(:todos)
    |> validate_required([:user_id, :list_name])
  end
end
