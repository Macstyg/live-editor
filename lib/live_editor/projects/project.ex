defmodule LiveEditor.Projects.Project do
  @moduledoc """
  The schema for projects.
  """
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
    |> cast(attrs, [:name, :description, :user_id, :id])
    |> validate_required([:name, :user_id])
    |> unique_constraint([:name, :user_id], name: :projects_name_user_id_idx)
  end
end
