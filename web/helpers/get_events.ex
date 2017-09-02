defmodule Samwise.GetEvents do
  @moduledoc """
  This module creates a list of events to forecast
  """

  alias Samwise.Money.Bill
  alias Samwise.Money.Income
  alias Samwise.Money.BillController
  alias Samwise.Money.IncomeController
  alias Samwise.Money.BudgetController
  alias Samwise.Money.BankAccountController
  alias Samwise.SmartDate

  # Use bills and incomes as default events
  def default_items do
    incomes = IncomeController.all_incomes()
    bills = BillController.all_bills()
    incomes ++ bills
  end

  # Make a list of events complete with events and budgets
  def all do
    all(default_items(), 90)
  end

  def all(forecast_items, days) do
    start_date = Timex.today
    balance = BankAccountController.balance()
    all(days, start_date, forecast_items, balance)
  end

  def all(days, start_date, forecast_items, balance) do
    days
      |> get_dates_map(start_date)
      |> add_events_to_forecast(forecast_items, balance, [])
      |> add_min_max_budgets()
  end

  # Get smallest balance from forecast as amount safe to spend
  def get_available_to_spend do
    events_list = all()
    get_available_to_spend(events_list)
  end

  def get_available_to_spend([head | tail]) do
    get_available_to_spend(tail, head.min_balance)
  end

  def get_available_to_spend([head | tail], smallest) do
    case smallest > head.min_balance do
      true -> get_available_to_spend(tail, head.min_balance)
      false -> get_available_to_spend(tail, smallest)
    end
  end

  def get_available_to_spend([], smallest) do
    smallest - BankAccountController.cushion()
  end

  # Build list of dates for N days
  def get_dates_map(days, date) do get_dates_map(days, date, []) end

  def get_dates_map(days, date, dates_list) when days > 0 do
    next_date = Timex.shift(date, days: 1)
    item = %{date: SmartDate.simple_date(date), day: date.day, events: []}
    get_dates_map(days - 1, next_date, [item | dates_list])
  end

  def get_dates_map(days, _date, dates_list) when days == 0 do
    Enum.reverse(dates_list)
  end

  # Add events to Forecast
  def add_events_to_forecast([head | tail], events_list, balance, acc) do
    events = events_on_day(events_list, head.day, [])
    new_balance = balance_after_events(events, balance)
    updated_item = head
      |> Map.put(:events, events)
      |> Map.put(:max_balance, new_balance)
    updated_acc = acc ++ [updated_item]
    add_events_to_forecast(tail, events_list, new_balance, updated_acc)
  end

  def add_events_to_forecast([], _events_list, _balance, acc) do
    acc
  end

  # Add event to day if it matches the due date
  def events_on_day([head | tail], day, acc) do
    updated_acc = case head.due == day do
      true -> acc ++ [item_to_map(head)]
      false -> acc
    end

    events_on_day(tail, day, updated_acc)
  end

  def events_on_day([], _day, acc) do
    acc
  end

  # Convert structs to maps to add it to the events list
  def item_to_map(item) do
    type = case item.__struct__ do
      Income -> "income"
      Bill -> "bill"
    end
    url = case item.__struct__ do
      Income -> nil
      Bill -> item.url
    end
    item
      |> Map.from_struct()
      |> Map.delete(:__meta__)
      |> Map.delete(:inserted_at)
      |> Map.delete(:updated_at)
      |> Map.delete(:id)
      |> Map.put(:type, type)
      |> Map.put(:url, url)
  end

  def balance_after_events([head | tail], balance) do
    new_balance = case head.type do
      "income" -> balance + head.amount
      "bill" -> balance - head.amount
    end

    balance_after_events(tail, new_balance)
  end

  def balance_after_events([], balance) do
    balance
  end

  # Add min & max budgets to forecast list

  def add_min_max_budgets(dates_list) do
    budgets_daily = BudgetController.daily_average()
    add_min_max_budgets(dates_list, budgets_daily, [], 1)
  end

  def add_min_max_budgets([head | tail], budgets_daily, acc, index) do
    min_balance = head.max_balance - (budgets_daily * index)
    updated_item = Map.put(head, :min_balance, min_balance)
    updated_acc = acc ++ [updated_item]
    add_min_max_budgets(tail, budgets_daily, updated_acc, index + 1)
  end

  def add_min_max_budgets([], _budgets_daily, acc, _index) do
    acc
  end

  # Transform all that into something the chart can digest

  def transform_to_chart_data(events) do
    transform_to_chart_data(events, [], [])
  end

  def transform_to_chart_data([head | tail], min_acc, max_acc) do
    updated_min_acc = case head.events != [] do
      true -> min_acc ++ [[head.date, head.min_balance]]
      false -> min_acc
    end

    updated_max_acc = case head.events != [] do
      true -> max_acc ++ [[head.date, head.max_balance]]
      false -> max_acc
    end

    transform_to_chart_data(tail, updated_min_acc, updated_max_acc)
  end

  def transform_to_chart_data([], min_acc, max_acc) do
    [%{
      name: "Minimum balance",
      data: max_acc
    },
    %{
      name: "Maximum balance",
      data: min_acc
    }]
  end

  # Get events that happen on specific day
  def on_day(day) do
    on_day(default_items(), day)
  end

  def on_day(items, day) do
    items
      |> Enum.filter(fn(x) -> x.due == day end)
  end
end
