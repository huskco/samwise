defmodule Samwise.Repo.Migrations.CreateSchool.Course do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :grade, :float
      add :student_id, references(:students, on_delete: :nothing)

      timestamps()
    end

    create index(:courses, [:student_id])
  end
end
