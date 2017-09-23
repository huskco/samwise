defmodule Samwise.Repo.Migrations.CreateSchool.SchoolDashboard do
  use Ecto.Migration

  def change do
    create table(:school_dashboard) do

      timestamps()
    end
  end
end
