defmodule Client.Users.User do
  defstruct [:email, :password]
  @types %{email: :string, password: :string}

  alias Client.Users.User
  import Ecto.Changeset

  def changeset(%User{} = user_body, attrs) do
    {user_body, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
  end
end
