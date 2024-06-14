defmodule LiveEditor.Repo.Migrations.AddIsPublic do
  use Ecto.Migration

  def change do
    alter table(:projects) do
      add :is_public, :boolean, default: false
    end
  end
end
