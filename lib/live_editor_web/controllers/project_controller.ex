defmodule LiveEditorWeb.ProjectController do
  use LiveEditorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
