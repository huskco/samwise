defmodule Samwise.Money.Bill do
  use Samwise.Web, :model

  schema "bills" do
    field :name, :string
    field :url, :string
    field :due, :integer
    field :amount, :float
    field :autopay, :boolean

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :due, :amount, :autopay])
    |> validate_required([:name, :due, :amount, :autopay])
  end
end
