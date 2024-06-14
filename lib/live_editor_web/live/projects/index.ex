defmodule LiveEditorWeb.ProjectsLive.Index do
  alias LiveEditor.Projects
  alias LiveEditor.Projects.Project
  use LiveEditorWeb, :live_view

  def mount(_params, _session, socket) do
    if connected?(socket), do: Projects.subscribe()
    socket = socket |> assign_projects() |> assign_filter_form()

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    user_id = socket.assigns.current_user.id
    socket = socket |> assign_form(user_id, id)

    {:noreply, socket}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    user_id = socket.assigns.current_user.id

    socket =
      socket.assigns.live_action
      |> case do
        :new -> socket |> assign_form(user_id)
        _ -> socket
      end

    {:noreply, socket}
  end

  def handle_event("filter", %{"search" => term}, socket) do
    projects =
      case String.length(term) > 0 do
        false ->
          socket.assigns.projects

        true ->
          socket.assigns.projects
          |> Enum.filter(fn project ->
            project.name |> String.downcase() |> String.contains?(term |> String.downcase())
          end)
      end

    {:noreply, assign(socket, filtered_projects: projects)}
  end

  def handle_event("submit", %{"project" => project_params}, socket) do
    params = project_params |> Map.put("user_id", socket.assigns.current_user.id)

    socket =
      socket.assigns.live_action
      |> case do
        :edit ->
          handle_edit_project(socket, params)

        :new ->
          handle_create_project(socket, params)
      end

    {:noreply, push_patch(socket, to: "/projects")}
  end

  defp handle_create_project(socket, params) do
    Projects.create(params)
    |> case do
      {:ok, project} ->
        project = project |> Projects.preload_user()
        projects = [project | socket.assigns.projects]

        socket
        |> assign(projects: projects, filtered_projects: projects)
        |> put_flash(:info, "Project #{project.name} created successfully")

      {:error, %Ecto.Changeset{} = changeset} ->
        assign(socket, form: to_form(changeset))
    end
  end

  defp handle_edit_project(socket, params) do
    Projects.edit(params)
    |> case do
      {:ok, project} ->
        projects =
          project
          |> Projects.preload_user()
          |> get_updated_projects(socket.assigns.projects)

        socket
        |> assign(projects: projects, filtered_projects: projects)
        |> put_flash(:info, "Project #{project.name} updated successfully")

      {:error, :not_found} ->
        socket
    end
  end

  defp get_updated_projects(updated_project, projects) do
    projects
    |> Enum.map(fn project ->
      case project.id == updated_project.id do
        true -> updated_project
        _ -> project
      end
    end)
  end

  defp assign_projects(socket) do
    user_id = socket.assigns.current_user.id
    projects = Projects.list_all_with_user(user_id)

    assign(socket, projects: projects, filtered_projects: projects)
  end

  defp assign_form(socket, user_id) do
    form = Project.changeset(%Project{user_id: user_id}) |> to_form()

    assign(socket, form: form)
  end

  defp assign_form(socket, user_id, project_id) do
    form =
      Projects.get_by_id(user_id, project_id)
      |> case do
        {:ok, project} ->
          Project.changeset(project) |> to_form()

        _ ->
          Project.changeset(%Project{user_id: user_id}) |> to_form()
      end

    assign(socket, form: form)
  end

  defp assign_filter_form(socket) do
    assign(socket, filter_form: to_form(%{"search" => ""}))
  end

  def handle_info({Projects, [:project, _], _}, socket) do
    {:noreply, assign_projects(socket)}
  end
end
