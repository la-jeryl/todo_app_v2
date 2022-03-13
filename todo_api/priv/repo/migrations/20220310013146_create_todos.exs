defmodule TodoApi.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :priority, :integer, null: false
      add :title, :string, null: false
      add :description, :string, null: true
      add :is_done, :boolean, default: false, null: false
      add :list_id, references(:lists, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:todos, [:list_id])
  end
end
