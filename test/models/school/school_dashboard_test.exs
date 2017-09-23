defmodule Samwise.School.SchoolDashboardTest do
  use Samwise.ModelCase

  alias Samwise.School.SchoolDashboard

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SchoolDashboard.changeset(%SchoolDashboard{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SchoolDashboard.changeset(%SchoolDashboard{}, @invalid_attrs)
    refute changeset.valid?
  end
end
