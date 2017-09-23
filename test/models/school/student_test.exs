defmodule Samwise.School.StudentTest do
  use Samwise.ModelCase

  alias Samwise.School.Student

  @valid_attrs %{name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Student.changeset(%Student{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Student.changeset(%Student{}, @invalid_attrs)
    refute changeset.valid?
  end
end
