defmodule Client.Todos.Todo do
  defstruct [:title, :description, :priority, :is_done]
  @types %{title: :string, description: :string, priority: :integer, is_done: :boolean}

  alias Client.Todos.Todo
  import Ecto.Changeset

  def changeset(%Todo{} = todo_body, attrs) do
    {todo_body, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:title])
  end
end
