defmodule LiveEditor.Messages do
  @moduledoc """
  The module for messages context.
  """
  alias LiveEditor.Messages.Message
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

  def get_by_comment_id(comment_id) do
    Repo.all(from m in Message, where: m.comment_id == ^comment_id)
  end

  def create(attrs) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
    |> notify_subscribers([:message, :created])
  end
end
