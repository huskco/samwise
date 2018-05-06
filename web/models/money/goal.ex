defmodule Samwise.Money.Goal do
  @moduledoc """
  Goal Model for Money
  """
  use Samwise.Web, :model

  schema "goals" do
    field :name, :string
    field :url, :string
    field :amount, :float
    field :imageUrl, :string
    field :isDebt, :boolean, default: false
    field :order, :integer
    field :comments, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :amount, :imageUrl, :isDebt, :order, :comments])
    |> validate_required([:name, :amount, :isDebt, :order])
  end
end
