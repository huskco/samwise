defmodule Samwise.Money.Budget do
  @moduledoc """
  Budget Model for Money
  """
  use Samwise.Web, :model

  schema "budgets" do
    field :name, :string
    field :url, :string
    field :amount, :float
    field :comments, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :amount, :comments])
    |> validate_required([:name, :amount])
  end
end
