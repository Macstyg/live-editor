defmodule LiveEditor.Repo.Migrations.AddCommentMessages do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:messages) do
      add :text, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :comment_id, references(:comments, on_delete: :delete_all)
      timestamps()
    end
  end
end
