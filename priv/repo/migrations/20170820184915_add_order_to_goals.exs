defmodule Samwise.Repo.Migrations.AddOrderToGoals do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      add :order, :integer
    end
  end
end
