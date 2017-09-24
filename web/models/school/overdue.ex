defmodule Samwise.School.Overdue do
  use Samwise.Web, :model

  schema "overdues" do
    field :name, :string
    field :due, :naive_datetime
    belongs_to :course, Samwise.School.Course, foreign_key: :course_id

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :due])
    |> validate_required([:name, :due])
  end
end
