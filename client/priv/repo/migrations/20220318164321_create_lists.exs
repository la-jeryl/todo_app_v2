defmodule Client.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :list_name, :string
      add :user_id, :integer

      timestamps()
    end
  end
end
