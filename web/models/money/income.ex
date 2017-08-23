defmodule Samwise.Money.Income do
  @moduledoc """
  Income Model for Money
  """
  use Samwise.Web, :model

  schema "incomes" do
    field :name, :string
    field :due, :integer
    field :amount, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :due, :amount])
    |> validate_required([:name, :due, :amount])
  end
end
