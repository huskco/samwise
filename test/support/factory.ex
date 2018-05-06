defmodule Samwise.Factory do
  @moduledoc """
    Factory to help test users
  """
  use ExMachina.Ecto, repo: Samwise.Repo

  def user_factory do
    %Samwise.User{
      token: "ffnebyt73bich9",
      email: "batman@example.com",
      first_name: "Bruce",
      last_name: sequence("Wayne"),
      provider: "google"
    }
  end

  def bank_account_factory do
    %Samwise.Money.BankAccount{
      name: sequence(:name, &"Bank Account #{&1}"),
      amount: sequence(:amount, &"#{&1}000.00"),
      is_available: true,
      is_investment: false,
      is_allowance: false,
      show_on_dashboard: true,
      comments: nil
    }
  end

  def bill_factory do
    %Samwise.Money.Bill{
      name: sequence("BillName"),
      url: "billexample.com",
      due: 15,
      amount: sequence(:amount, &"#{&1}00.00"),
      autopay: true
    }
  end

  def budget_factory do
    %Samwise.Money.Budget{
      name: sequence("BudgetName"),
      url: "budgetexample.com",
      amount: sequence(:amount, &"#{&1}00.00"),
    }
  end

  def goal_factory do
    %Samwise.Money.Goal{
      name: sequence("GoalName"),
      url: "goalexample.com",
      amount: sequence(:amount, &"#{&1 * 2}00.00"),
      imageUrl: "goalexample.com/image.png",
      isDebt: false,
      order: 1
    }
  end

  def income_factory do
    %Samwise.Money.Income{
      name: sequence("IncomeName"),
      due: 1,
      amount: sequence(:amount, &"#{&1}000.00"),
    }
  end
end
