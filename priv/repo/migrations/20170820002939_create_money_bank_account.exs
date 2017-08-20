defmodule Samwise.Repo.Migrations.CreateMoney.BankAccount do
  use Ecto.Migration

  def change do
    create table(:bankaccount) do
      add :balance, :float
      add :savings, :float
      add :cushion, :float

      timestamps()
    end

    alter table(:bills) do
      add :autopay, :boolean
    end
  end
end
