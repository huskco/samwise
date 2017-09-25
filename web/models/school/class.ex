defmodule Samwise.School.Class do
  @moduledoc """
  Classes Model for School
  """
  use Samwise.Web, :model

  schema "classes" do
    field :name, :string
    field :start_time, :string
    field :end_time, :string
    field :required, :boolean, default: false
    belongs_to :course, Samwise.School.Course, foreign_key: :course_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :start_time, :end_time, :required])
    |> validate_required([:name, :start_time, :end_time, :required])
  end
end
