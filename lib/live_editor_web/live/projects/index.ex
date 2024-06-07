defmodule LiveEditorWeb.ProjectsLive.Index do
  alias LiveEditor.Projects
  use LiveEditorWeb, :live_view

  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id

    projects = [
      %{name: "Project 1", description: "Project description 1"},
      %{name: "Project 2", description: "Project description 2"}
    ]

    {:ok, assign(socket, :projects, projects)}
  end
end
