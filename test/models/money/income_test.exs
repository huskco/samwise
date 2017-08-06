defmodule Samwise.Money.IncomeTest do
  use Samwise.ModelCase

  alias Samwise.Money.Income

  @valid_attrs %{amount: 42, due: 1, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Income.changeset(%Income{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Income.changeset(%Income{}, @invalid_attrs)
    refute changeset.valid?
  end
end
