defmodule Samwise.Slack.Commands do
  @moduledoc """
  A helpful bot for Ogles
  """

  alias Samwise.Money.BankAccountController
  alias Samwise.SharedView
  alias Samwise.GetEvents
  alias Number.Currency

  def match(text) do
    case text do
      "What is my balance?" -> handle_balance()
      "How much can I spend?" -> handle_available_to_spend()
      "Money summary" -> money_summary()
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

    %{message: "Your balance is #{balance}, with #{savings} in savings"}
  end

  def handle_available_to_spend do
    amount = GetEvents.get_available_to_spend() |> add_currency
    %{message: "You have #{amount} available"}
  end

  def money_summary do
    daily_events = GetEvents.on_day(Timex.today().day)
    money_summary(daily_events)
  end

  def money_summary(daily_events) do
    daily_income = daily_events
      |> Enum.filter(fn(event) -> event.__struct__ == Samwise.Money.Income end)
    daily_bills = daily_events
      |> Enum.filter(fn(event) -> event.__struct__ == Samwise.Money.Bill end)
    daily_autopay_bills_list = daily_bills
      |> Enum.filter(fn(event) -> event.autopay end)
    daily_manual_bills_list = daily_bills
      |> Enum.filter(fn(event) -> !event.autopay end)
    balance = BankAccountController.balance() |> add_currency
    available = GetEvents.get_available_to_spend() |> add_currency

    summary_greeting = "Good morning, here is your money update for today:"

    message = "You have #{balance} total (#{available} is safe to spend)"
    summary_account = %{
      color: "#bfd849",
      text: message
    }

    summary_payday = if Enum.any?(daily_income) do
      %{
        color: "#ebe8e6",
        text: "It's pay day! #{SharedView.good_emoji()}"
      }
    end

    summary_autopay = if Enum.any?(daily_autopay_bills_list) do
      list = daily_autopay_bills_list
        |> Enum.map(fn(event) ->
          "#{event.name} (#{Currency.number_to_currency event.amount})"
        end)
        |> Enum.join(", ")

      %{
        color: "#ebe8e6",
        text: "Pay these bills today: #{list}"
      }
    end

    summary_manual = if Enum.any?(daily_manual_bills_list) do
      list = daily_manual_bills_list
        |> Enum.map(fn(event) ->
          "#{event.name} (#{Currency.number_to_currency event.amount})"
        end)
        |> Enum.join(", ")

      %{
        color: "#f4da5c",
        text: "Bills coming out automatically: #{list}"
      }
    end

    summary_nobills = unless Enum.any?(daily_bills) do
      %{
        color: "#ebe8e6",
        text: "No bills due today! #{SharedView.good_emoji()}"
      }
    end

    {:ok, attachments} = [summary_account, summary_payday, summary_autopay,
      summary_manual, summary_nobills]
      |> Enum.reject(fn(item) -> item == nil end)
      |> Poison.encode

    %{
      message: message,
      options: %{
        text: summary_greeting,
        attachments: attachments
      }
    }
  end
end
