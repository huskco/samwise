defmodule Samwise.Repo.Migrations.CreateMoney.Income do
  use Ecto.Migration

  def change do
    create table(:incomes) do
      add :name, :string
      add :dates, {:array, :integer}
      add :amount, :float

      timestamps()
    end

  end
end
