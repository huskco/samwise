defmodule Samwise.Repo.Migrations.CreateMoney.Goal do
  use Ecto.Migration

  def change do
    create table(:goals) do
      add :name, :string
      add :url, :string
      add :amount, :float
      add :imageUrl, :string
      add :isDebt, :boolean, default: false, null: false

      timestamps()
    end

  end
end
