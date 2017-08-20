defmodule Samwise.Money.BankAccountTest do
  use Samwise.ModelCase

  alias Samwise.Money.BankAccount

  @valid_attrs %{balance: 42, cushion: 42, savings: 42}
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
