defmodule LiveEditor.Projects do
  @moduledoc """
  Projects context
  """

  import Ecto.Query
  alias LiveEditor.Projects.Project
  alias LiveEditor.Repo

  defp query_by_user_id(user_id) do
    from p in Project, where: p.user_id == ^user_id
  end

  def list_all(user_id) do
    Repo.all(from p in query_by_user_id(user_id), order_by: [desc: p.inserted_at])
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
  end

  def edit(%{"user_id" => user_id, "id" => id} = args) do
    get_by_id(user_id, id)
    |> case do
      {:ok, project} ->
        project
        |> Project.changeset(args)
        |> Repo.update()

      _ ->
        {:error, :not_found}
    end
  end

  def preload_user(project) do
    project |> Repo.preload(:user)
  end
end
