defmodule Samwise.School.Course do
  @moduledoc """
  Courses Model for School
  """
  use Samwise.Web, :model

  schema "courses" do
    field :name, :string
    field :grade, :float
    belongs_to :student, Samwise.School.Student, foreign_key: :student_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :grade])
    |> validate_required([:name, :grade])
  end
end
