defmodule Samwise.School.ClassTest do
  use Samwise.ModelCase

  alias Samwise.School.Class

  @valid_attrs %{
    end_time: "some end_time",
    name: "some name",
    required: true,
    start_time: "some start_time"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Class.changeset(%Class{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Class.changeset(%Class{}, @invalid_attrs)
    refute changeset.valid?
  end
end
