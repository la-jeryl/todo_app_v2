defmodule Client.Lists.List do
  defstruct [:list_name]
  @types %{list_name: :string}

  alias Client.Lists.List
  import Ecto.Changeset

  def changeset(%List{} = list_body, attrs) do
    {list_body, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:list_name])
  end
end
