defmodule LiveEditor.Projects do
  @moduledoc """
  Projects context
  """

  import Ecto.Query
  alias LiveEditor.Projects.Project
  alias LiveEditor.Repo

  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(LiveEditor.PubSub, @topic)
  end

  defp query_by_user_id(user_id) do
    from p in Project, where: p.user_id == ^user_id
  end

  def list_all(user_id) do
    Repo.all(
      from p in query_by_user_id(user_id),
        or_where: p.is_public == true,
        order_by: [desc: p.inserted_at]
    )
  end

  def list_all_with_user(user_id) do
    user_id |> list_all() |> preload_user()
  end

  def get_by_id(user_id, project_id) do
    Repo.one(from p in query_by_user_id(user_id), where: p.id == ^project_id)
    |> case do
      nil -> {:error, "Project not found"}
      project -> {:ok, project}
    end
  end

  def create(args) do
    %Project{}
    |> Project.changeset(args)
    |> Repo.insert()
    |> notify_subscribers([:project, :created])
  end

  def edit(%{"user_id" => user_id, "id" => id} = args) do
    get_by_id(user_id, id)
    |> case do
      {:ok, project} ->
        project
        |> Project.changeset(args)
        |> Repo.update()
        |> notify_subscribers([:project, :updated])

      _ ->
        {:error, :not_found}
    end
  end

  def preload_user(project) do
    project |> Repo.preload(:user)
  end

  defp notify_subscribers({:ok, result}, event) do
    Phoenix.PubSub.broadcast(LiveEditor.PubSub, @topic, {__MODULE__, event, result})
    {:ok, result}
  end

  defp notify_subscribers({:error, reason}, _event), do: {:error, reason}
end
