defmodule Samwise.Money.Income do
  use Samwise.Web, :model

  schema "incomes" do
    field :name, :string
    field :dates, {:array, :integer}
    field :amount, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :dates, :amount])
    |> validate_required([:name, :dates, :amount])
  end
end
