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
      "Money summary" -> money_summary(%{with_emojis: true})
      _ -> false
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
    money_summary(%{events: daily_events, with_emojis: true})
  end

  def money_summary(%{events: daily_events, with_emojis: with_emojis}) do
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

    summary_account = %{
      color: "#bfd849",
      text: "You have #{balance} total (*#{available} is safe to spend*)",
      mrkdwn_in: ["text"]
    }

    summary_payday_emoji = if with_emojis, do: SharedView.good_emoji()
    summary_payday = if Enum.any?(daily_income) do
      %{
        color: "#bfd849",
        text: "It's pay day! #{summary_payday_emoji}"
      }
    end

    summary_autopay = if Enum.any?(daily_autopay_bills_list) do
      list = daily_autopay_bills_list
        |> Enum.map(fn(event) ->
          "#{event.name} (#{Currency.number_to_currency event.amount})"
        end)
        |> Enum.join(", ")

      %{
        color: "#f4da5c",
        text: "*Bills coming out automatically:* #{list}",
        mrkdwn_in: ["text"]
      }
    end

    summary_manual = if Enum.any?(daily_manual_bills_list) do
      list = daily_manual_bills_list
        |> Enum.map(fn(event) ->
          "#{event.name} (#{Currency.number_to_currency event.amount})"
        end)
        |> Enum.join(", ")

      %{
        color: "#f15729",
        text: "*Pay these bills today:* #{list}",
        mrkdwn_in: ["text"]
      }
    end

    summary_nobills_emoji = if with_emojis, do: SharedView.good_emoji()
    summary_nobills = unless Enum.any?(daily_bills) do
      %{
        color: "#ebe8e6",
        text: "No bills due today! #{summary_nobills_emoji}"
      }
    end

    {:ok, attachments} = [summary_account, summary_payday, summary_autopay,
      summary_manual, summary_nobills]
      |> Enum.reject(fn(item) -> item == nil end)
      |> Poison.encode

    %{
      message: "Good morning, here is your money update for today:",
      options: %{
        attachments: attachments,
      }
    }
  end
end
