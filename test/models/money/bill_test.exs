defmodule Samwise.Money.BillTest do
  use Samwise.ModelCase

  alias Samwise.Money.Bill

  @valid_attrs %{amount: 42, due: 42, name: "some content", url: "some content", autopay: false}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bill.changeset(%Bill{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bill.changeset(%Bill{}, @invalid_attrs)
    refute changeset.valid?
  end
end
