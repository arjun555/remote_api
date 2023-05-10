defmodule RemoteApi.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :points, :integer, null: false

      timestamps()
    end

    create constraint(:users, :points_range, check: "points >= 0 AND points <= 100")
    create index(:users, [:points])
  end
end
