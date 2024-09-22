defmodule Carafe.Repo do
  use Ecto.Repo,
    otp_app: :carafe,
    adapter: Ecto.Adapters.SQLite3

  use Paginator
end
