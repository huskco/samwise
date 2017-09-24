defmodule Samwise.School.OverdueTest do
  use Samwise.ModelCase

  alias Samwise.School.Overdue

  @valid_attrs %{due: ~N[2010-04-17 14:00:00.000000], name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Overdue.changeset(%Overdue{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Overdue.changeset(%Overdue{}, @invalid_attrs)
    refute changeset.valid?
  end
end
