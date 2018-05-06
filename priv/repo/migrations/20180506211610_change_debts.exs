defmodule Samwise.Repo.Migrations.ChangeDebts do
  use Ecto.Migration

  def change do
    alter table(:goals) do
      remove :isDebt
    end

    alter table(:bills) do
      add :is_debt, :boolean
    end

    alter table(:bankaccount) do
      add :is_debt, :boolean
    end
  end
end
