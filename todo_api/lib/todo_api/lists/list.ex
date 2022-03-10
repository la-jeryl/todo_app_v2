defmodule TodoApi.Lists.List do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lists" do
    field :list_name, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:user_id, :list_name])
    |> validate_required([:user_id, :list_name])
  end
end
