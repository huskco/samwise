defmodule Samwise.Money.Bill do
  @moduledoc """
  Bill Model for Money
  """
  use Samwise.Web, :model

  schema "bills" do
    field :name, :string
    field :url, :string
    field :due, :integer
    field :amount, :float
    field :autopay, :boolean, default: false
    field :is_debt, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :due, :amount, :autopay, :is_debt])
    |> validate_required([:name, :due, :amount, :autopay, :is_debt])
  end
end
