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
      "How much can I spend?" -> handle_safe_to_spend()
      "Money summary" -> money_summary(%{with_emojis: true})
      _ -> false
    end
  end

  def add_currency(number) do
    number |> Currency.number_to_currency
  end

  # Known commands

  def handle_balance do
    total_available = BankAccountController.total_available() |> add_currency

    %{message: "You have #{total_available} available to spend"}
  end

  def handle_safe_to_spend do
    amount = GetEvents.get_safe_to_spend() |> add_currency
    %{message: "You have #{amount} safe to spend"}
  end

  def money_summary(with_emojis) do
    daily_events = GetEvents.on_day(Timex.today().day)
    money_summary(daily_events, with_emojis)
  end

  def money_summary(daily_events, with_emojis) do
    total_available = BankAccountController.total_available() |> add_currency
    safe_to_spend = GetEvents.get_safe_to_spend() |> add_currency

    money_summary(daily_events, total_available, safe_to_spend, with_emojis)
  end

  def money_summary(daily_events, total_available, safe_to_spend, with_emojis) do
    show_total_available = total_available |> add_currency
    show_safe_to_spend = safe_to_spend |> add_currency
    income_events = get_income_events(daily_events)
    bill_events = get_bill_events(daily_events)
    summary_payday = summary_payday(income_events, with_emojis)
    summary_autopay = get_autopay_bill_events(bill_events)
    summary_manual = get_manual_bill_events(bill_events)
    summary_no_bills = summary_no_bills(bill_events, with_emojis)

    summary_account = %{
      color: "#bfd849",
      text: "You have #{show_total_available} available (*#{show_safe_to_spend} safe to spend*)",
      mrkdwn_in: ["text"]
    }

    {:ok, attachments} = [summary_account, summary_payday, summary_autopay,
      summary_manual, summary_no_bills]
      |> Enum.reject(fn(item) -> item == nil end)
      |> Poison.encode

    %{
      message: "Good morning, here is your money update for today:",
      options: %{
        attachments: attachments,
      }
    }
  end

  defp get_income_events(events) do
    events
      |> Enum.filter(fn(event) -> event.__struct__ == Samwise.Money.Income end)
  end

  defp get_bill_events(events) do
    events
      |> Enum.filter(fn(event) -> event.__struct__ == Samwise.Money.Bill end)
  end

  defp get_autopay_bill_events(bill_events) do
    daily_autopay_bills_list = bill_events
      |> Enum.filter(fn(event) -> event.autopay end)
    if Enum.any?(daily_autopay_bills_list) do
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
  end

  defp get_manual_bill_events(bill_events) do
    daily_manual_bills_list = bill_events
      |> Enum.filter(fn(event) -> !event.autopay end)
    if Enum.any?(daily_manual_bills_list) do
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
  end

  defp summary_no_bills(bill_events, with_emojis) do
    unless Enum.any?(bill_events) do
      emoji = if with_emojis, do: SharedView.good_emoji()
      %{
        color: "#ebe8e6",
        text: "No bills due today! #{emoji}"
      }
    end
  end

  defp summary_payday(bill_events, with_emojis) do
    if Enum.any?(bill_events) do
      emoji = if with_emojis, do: SharedView.good_emoji()
      %{
        color: "#bfd849",
        text: "It's pay day! #{emoji}"
      }
    end
  end
end
