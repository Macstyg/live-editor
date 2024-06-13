defmodule LiveEditor.Comments.Comment do
  @moduledoc """
  The schema for comments.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :x, :integer
    field :y, :integer

    belongs_to :user, LiveEditor.Accounts.User
    belongs_to :project, LiveEditor.Projects.Project

    timestamps(type: :utc_datetime)
  end

  def changeset(comment, attrs \\ %{}) do
    comment
    |> cast(attrs, [:x, :y, :user_id, :project_id, :id])
    |> validate_required([:x, :y, :user_id, :project_id])
  end
end
