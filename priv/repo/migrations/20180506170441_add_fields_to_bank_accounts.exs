defmodule Samwise.Repo.Migrations.AddFieldsToBankAccounts do
  use Ecto.Migration

  def change do
    alter table(:bankaccount) do
      remove :balance
      remove :savings
      remove :cushion

      add :name, :string
      add :amount, :float
      add :is_available, :boolean
      add :is_investment, :boolean
      add :is_allowance, :boolean
      add :show_on_dashboard, :boolean
      add :comments, :string
    end
  end
end
