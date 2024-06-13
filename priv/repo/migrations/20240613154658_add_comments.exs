defmodule LiveEditor.Repo.Migrations.AddComments do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:comments) do
      add :x, :int
      add :y, :int
      add :user_id, references(:users, on_delete: :delete_all)
      add :project_id, references(:projects, on_delete: :delete_all)

      timestamps()
    end
  end
end
