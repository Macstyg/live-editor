defmodule LiveEditor.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string

    belongs_to :user, LiveEditor.Accounts.User

    timestamps(type: :utc_datetime)
  end

  def changeset(project, attrs \\ %{}) do
    project
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :user_id])
  end
end
