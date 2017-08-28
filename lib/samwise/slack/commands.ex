defmodule Samwise.Slack.Commands do
  @moduledoc """
  A helpful bot for Ogles
  """
  alias Samwise.Money.BankAccountController
  alias Samwise.Money.ForecastController
  alias Number.Currency

  def match(text) do
    case text do
      "What is my balance?" -> handle_balance()
      "How much can I spend?" -> handle_available_to_spend()
      # _ -> "Sorry #{slacker_name}, I didn't understand that"
    end
  end

  def add_currency(number) do
    number |> Currency.number_to_currency
  end

  # Known commands

  def handle_balance do
    balance = BankAccountController.balance() |> add_currency
    savings = BankAccountController.savings() |> add_currency
    "Your balance is #{balance}, with #{savings} in savings"
  end

  def handle_available_to_spend do
    amount = ForecastController.get_available_to_spend() |> add_currency
    "You have #{amount} available"
  end
end
