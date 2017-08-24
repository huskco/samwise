defmodule Samwise.Money.GoalTest do
  use Samwise.ModelCase

  alias Samwise.Money.Goal

  @valid_attrs %{
    amount: 42,
    imageUrl: "some content",
    isDebt: true,
    name: "some content",
    url: "some content",
    order: 1
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Goal.changeset(%Goal{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Goal.changeset(%Goal{}, @invalid_attrs)
    refute changeset.valid?
  end
end
