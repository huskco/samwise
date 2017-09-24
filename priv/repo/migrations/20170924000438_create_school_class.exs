defmodule Samwise.Repo.Migrations.CreateSchool.Class do
  use Ecto.Migration

  def change do
    create table(:classes) do
      add :name, :string
      add :start_time, :string
      add :end_time, :string
      add :required, :boolean, default: false, null: false
      add :course_id, references(:courses, on_delete: :nothing)

      timestamps()
    end

    create index(:classes, [:course_id])
  end
end
