defmodule Samwise.Repo.Migrations.AddComments do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      add :comments, :string
    end

    alter table(:budgets) do
      add :comments, :string
    end
  end
end
