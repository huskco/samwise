defmodule Samwise.Money.BankAccount do
  @moduledoc """
  Bank Account Model for Money
  """
  use Samwise.Web, :model

  schema "bankaccount" do
    field :name, :string
    field :amount, :float
    field :is_available, :boolean
    field :is_investment, :boolean
    field :is_allowance, :boolean
    field :show_on_dashboard, :boolean
    field :comments, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :name,
      :amount,
      :is_available,
      :is_investment,
      :is_allowance,
      :show_on_dashboard,
      :comments
    ])
    |> validate_required([
      :name,
      :amount,
      :is_available,
      :is_investment,
      :is_allowance,
      :show_on_dashboard
    ])
  end
end
