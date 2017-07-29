defmodule Samwise.Money.Budget do
  use Samwise.Web, :model

  schema "budgets" do
    field :name, :string
    field :url, :string
    field :amount, :float

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :amount])
    |> validate_required([:name, :url, :amount])
  end
end
