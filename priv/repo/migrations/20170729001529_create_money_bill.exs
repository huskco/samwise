defmodule Samwise.Repo.Migrations.CreateMoney.Bill do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :name, :string
      add :url, :string
      add :due, :integer
      add :amount, :float

      timestamps()
    end

  end
end
