defmodule Samwise.School.CourseTest do
  use Samwise.ModelCase

  alias Samwise.School.Course

  @valid_attrs %{grade: 120.5, name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Course.changeset(%Course{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Course.changeset(%Course{}, @invalid_attrs)
    refute changeset.valid?
  end
end
