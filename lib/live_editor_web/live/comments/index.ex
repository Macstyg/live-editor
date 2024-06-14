defmodule LiveEditorWeb.CommentsLive.Index do
  use LiveEditorWeb, :live_view
  alias LiveEditor.Comments
  alias LiveEditor.Messages

  def mount(%{"id" => project_id}, _uri, socket) do
    if connected?(socket), do: Comments.subscribe()
    if connected?(socket), do: Messages.subscribe()
    socket = socket |> assign_comments(project_id) |> assign_form()

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
          comment = comment |> Comments.preload_messages()

          socket
          |> assign(comments: [comment | socket.assigns.comments])
          |> put_flash(:info, "Comment added successfully")

        {:error, _changeset} ->
          socket |> put_flash(:error, "Error adding comment")
      end

    {:noreply, socket}
  end

  def handle_event("submit_message", params, socket) do
    socket =
      params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Messages.create()
      |> case do
        {:ok, message} ->
          message = message |> Messages.preload_user()

          comments =
            Enum.map(socket.assigns.comments, fn comment ->
              Map.update(comment, :messages, [], &(List.wrap(&1) ++ [message]))
            end)

          socket
          |> assign(comments: comments)
          |> assign_form()
          |> put_flash(:info, "Message added successfully")

        {:error, %Ecto.Changeset{} = changeset} ->
          socket
          |> assign(message_form: to_form(changeset))
          |> put_flash(:error, "Error adding message")
      end

    {:noreply, socket}
  end

  def assign_comments(socket, project_id) do
    comments = Comments.list_all(project_id)
    assign(socket, comments: comments, project_id: project_id)
  end

  def assign_form(socket) do
    assign(socket, message_form: to_form(%{"text" => ""}))
  end

  def handle_info({Comments, [:comment, _], _}, socket) do
    {:noreply, assign_comments(socket, socket.assigns.project_id)}
  end

  def handle_info({Messages, [:message, _], _}, socket) do
    {:noreply, assign_comments(socket, socket.assigns.project_id)}
  end
end
