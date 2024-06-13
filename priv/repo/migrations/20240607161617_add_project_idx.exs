defmodule LiveEditor.Repo.Migrations.AddProjectIdx do
  use Ecto.Migration
  @disable_ddl_transaction true
  @disable_migration_lock true

  def change do
    create_if_not_exists unique_index(:projects, [:name, :user_id],
                           name: :projects_name_user_id_idx,
                           concurrently: true
                         )
  end
end
