defmodule Carafe.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :carafe

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  ## FIXME: Cleaner code for Carafe.Release.seed/0 does not work, yet
  ## ** (RuntimeError) could not lookup Ecto repo Carafe.Repo because it was not started or it does not exist
  ## TODO: https://hexdocs.pm/ecto_sql/Ecto.Migrator.html#with_repo/3
  ## CAUTION: priv/repo.seeds.exs is not idempotent
  def seed do
    load_app()
    {:ok, _} = Code.eval_file("/app/lib/carafe-0.1.0/priv/repo/seeds.exs")
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
