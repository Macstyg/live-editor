defmodule LiveEditor.Repo.Migrations.AddProjects do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:projects) do
      add :name, :string
      add :description, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
