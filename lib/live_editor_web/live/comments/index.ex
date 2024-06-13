defmodule LiveEditorWeb.CommentsLive.Index do
  use LiveEditorWeb, :live_view
  alias LiveEditor.Comments

  def mount(%{"id" => project_id}, _uri, socket) do
    socket = socket |> assign_comments(project_id)

    {:ok, socket}
  end

  def handle_event("add_comment", args, socket) do
    socket =
      Map.new()
      |> Map.put(:user_id, socket.assigns.current_user.id)
      |> Map.put(:project_id, socket.assigns.project_id)
      |> Map.put(:x, args["pageX"])
      |> Map.put(:y, args["pageY"])
      |> Comments.create()
      |> case do
        {:ok, comment} ->
          socket
          |> assign(comments: [comment | socket.assigns.comments])
          |> put_flash(:info, "Comment added successfully")

        {:error, _changeset} ->
          socket |> put_flash(:error, "Error adding comment")
      end

    {:noreply, socket}
  end

  def assign_comments(socket, project_id) do
    comments = Comments.list_all(project_id)
    assign(socket, comments: comments, project_id: project_id)
  end
end
