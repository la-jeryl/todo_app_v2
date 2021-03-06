defmodule TodoApi.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :user_id, :integer, null: false
      add :list_name, :string, null: false

      timestamps()
    end
  end
end
