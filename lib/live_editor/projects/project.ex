defmodule LiveEditor.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(project, attrs \\ %{}) do
    project
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
