defmodule LiveEditor.Repo do
  use Ecto.Repo,
    otp_app: :live_editor,
    adapter: Ecto.Adapters.Postgres
end
