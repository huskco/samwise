defmodule Samwise.Money.Goal do
  use Samwise.Web, :model

  schema "goals" do
    field :name, :string
    field :url, :string
    field :amount, :float
    field :imageUrl, :string
    field :isDebt, :boolean, default: false
    field :order, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :amount, :imageUrl, :isDebt, :order])
    |> validate_required([:name, :amount, :isDebt, :order])
  end
end
