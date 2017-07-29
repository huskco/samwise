defmodule Samwise.Repo.Migrations.CreateMoney.Budget do
  use Ecto.Migration

  def change do
    create table(:budgets) do
      add :name, :string
      add :url, :string
      add :amount, :float

      timestamps()
    end

  end
end
