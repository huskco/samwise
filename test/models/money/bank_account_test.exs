defmodule Samwise.Money.BankAccountTest do
  use Samwise.ModelCase

  alias Samwise.Money.BankAccount

  @valid_attrs %{
    name: "Checking",
    amount: 10000.00,
    is_available: true,
    is_investment: false,
    is_allowance: false,
    show_on_dashboard: true,
    comments: "some content"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BankAccount.changeset(%BankAccount{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BankAccount.changeset(%BankAccount{}, @invalid_attrs)
    refute changeset.valid?
  end
end
