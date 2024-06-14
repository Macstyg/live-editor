defmodule LiveEditor.Messages do
  @moduledoc """
  The module for messages context.
  """
  alias LiveEditor.Messages.Message
  alias LiveEditor.Repo
  import Ecto.Query

  def get_by_comment_id(comment_id) do
    Repo.all(from m in Message, where: m.comment_id == ^comment_id)
  end

  def create(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end
end
