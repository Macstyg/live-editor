defmodule LiveEditor.Repo.Migrations.AddCommentsIdx do
  use Ecto.Migration
  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create_if_not_exists index(:comments, [:user_id, :project_id],
                           name: :user_id_project_id_idx,
                           concurrently: true
                         )
  end
end
