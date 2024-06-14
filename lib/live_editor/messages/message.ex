defmodule LiveEditor.Messages.Message do
  @moduledoc """
  A message that can be sent to a project.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :text, :string

    belongs_to :user, LiveEditor.Accounts.User
    belongs_to :comment, LiveEditor.Comments.Comment

    timestamps()
  end

  def changeset(message, attrs \\ %{}) do
    message
    |> cast(attrs, [:text, :user_id, :comment_id])
    |> validate_required([:text, :user_id, :comment_id])
  end
end
