defmodule Samwise.Money.BankAccount do
  @moduledoc """
  Bank Account Model for Money
  """
  use Samwise.Web, :model

  schema "bankaccount" do
    field :name, :string
    field :amount, :float
    field :is_available, :boolean, default: false
    field :is_investment, :boolean, default: false
    field :is_allowance, :boolean, default: false
    field :show_on_dashboard, :boolean, default: true
    field :is_debt, :boolean, default: false
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
      :is_debt,
      :comments
    ])
    |> validate_required([
      :name,
      :amount,
      :is_available,
      :is_investment,
      :is_allowance,
      :show_on_dashboard,
      :is_debt
    ])
  end
end
