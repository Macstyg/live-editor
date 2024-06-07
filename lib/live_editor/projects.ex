defmodule LiveEditor.Projects do
  alias DialyxirVendored.Project
  alias LiveEditor.Repo

  def list_all do
    Repo.all(Project)
  end
end
