defmodule LiveEditor.Comments do
  @moduledoc """
  Comments context
  """
  alias LiveEditor.Comments.Comment
  alias LiveEditor.Repo
  import Ecto.Query

  def list_all(project_id) do
    Repo.all(
      from c in Comment,
        preload: :messages,
        where: c.project_id == ^project_id,
        order_by: [desc: c.inserted_at]
    )
  end

  def create(args) do
    %Comment{}
    |> Comment.changeset(args)
    |> Repo.insert()
  end

  def preload_user(comment) do
    comment |> Repo.preload(:user)
  end

  def preload_messages(comment) do
    comment |> Repo.preload(:messages)
  end
end
