defmodule LiveEditor.Projects do
  @moduledoc """
  Projects context
  """

  import Ecto.Query
  alias LiveEditor.Projects.Project
  alias LiveEditor.Repo

  def list_all(user_id) do
    Repo.all(from p in Project, where: p.user_id == ^user_id)
  end
end
