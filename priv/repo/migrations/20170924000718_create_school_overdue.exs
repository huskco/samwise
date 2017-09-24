defmodule Samwise.Repo.Migrations.CreateSchool.Overdue do
  use Ecto.Migration

  def change do
    create table(:overdues) do
      add :name, :string
      add :due, :naive_datetime
      add :course_id, references(:courses, on_delete: :nothing)

      timestamps()
    end

    create index(:overdues, [:course_id])
  end
end
