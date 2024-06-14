defmodule LiveEditor.Comments do
  @moduledoc """
  Comments context
  """
  alias LiveEditor.Comments.Comment
  alias LiveEditor.Repo
  import Ecto.Query

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(LiveEditor.PubSub, @topic)
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(LiveEditor.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}

  def list_all(project_id) do
    Repo.all(
      from c in Comment,
        preload: [messages: [:user]],
        where: c.project_id == ^project_id,
        order_by: [desc: c.inserted_at]
    )
  end

  def create(args) do
    %Comment{}
    |> Comment.changeset(args)
    |> Repo.insert()
    |> notify_subscribers([:comment, :created])
  end

  def preload_user(comment) do
    comment |> Repo.preload(:user)
  end

  def preload_messages(comment) do
    comment |> Repo.preload(messages: [:user])
  end
end
