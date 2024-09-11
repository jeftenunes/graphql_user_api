defmodule GraphqlUserApi.Repo.Migrations.AddUniqueIdx2UsrEmail do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email])
  end
end
