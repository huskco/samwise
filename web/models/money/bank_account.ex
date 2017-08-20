defmodule Samwise.Money.BankAccount do
  use Samwise.Web, :model

  schema "bankaccount" do
    field :balance, :float
    field :savings, :float
    field :cushion, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:balance, :savings, :cushion])
    |> validate_required([:balance, :savings, :cushion])
  end
end
