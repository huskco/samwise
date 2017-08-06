defmodule Samwise.Repo.Migrations.MakeIncomesSingularDates do
  use Ecto.Migration

  def change do
    alter table(:incomes) do
      remove :dates
      add :due, :integer
    end
  end
end
