defmodule Samwise.Money.BudgetTest do
  use Samwise.ModelCase

  alias Samwise.Money.Budget

  @valid_attrs %{amount: 42, name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Budget.changeset(%Budget{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Budget.changeset(%Budget{}, @invalid_attrs)
    refute changeset.valid?
  end
end
