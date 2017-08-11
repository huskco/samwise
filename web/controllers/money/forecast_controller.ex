defmodule Samwise.Money.ForecastController do
  use Samwise.Web, :controller
  plug :add_service_layout, "money"

  def index(conn, _params) do
    bills_total = Samwise.Money.BillController.total()
    budgets_total = Samwise.Money.BudgetController.total()
    budgets_daily = Samwise.Money.BudgetController.daily_average()
    goals_total = Samwise.Money.GoalController.total()
    incomes_total = Samwise.Money.IncomeController.total()
    balance = 10000
    days_to_forecast = 120
    table_events = get_forecast_items()
    chart_events = get_dates_map(days_to_forecast, Timex.today, [])
      |> add_events_to_forecast(get_forecast_items(), balance, [])
      |> add_min_max_budgets(budgets_daily, [])

    render(conn,
      "index.html",
      bills_total: bills_total,
      budgets_total: budgets_total,
      budgets_daily: budgets_daily,
      goals_total: goals_total,
      incomes_total: incomes_total,
      table_events: table_events,
      chart_events: chart_events,
      balance: balance,
      page_title: "Forecast")
  end

  def add_service_layout(conn, service) do
    Samwise.SharedController.add_service_layout(conn, service)
  end

  # Build list of dates for N days

  def get_dates_map(days_to_forecast, date, dates_list \\ [])

  def get_dates_map(days_to_forecast, date, dates_list) when days_to_forecast > 0 do
    next_date = Timex.shift(date, days: 1)
    item = %{date: Samwise.NextDate.simple_date(date), day: date.day, events: []}
    get_dates_map(days_to_forecast - 1, next_date, [item | dates_list])
  end

  def get_dates_map(days_to_forecast, _date, dates_list) when days_to_forecast == 0 do
    Enum.reverse(dates_list)
  end

  # Add events to Forecast

  def add_events_to_forecast([head | tail], events_list, balance, acc) do
    events = events_on_day(events_list, head.day, [])
    new_balance = balance_after_events(events, balance)
    updated_item = Map.put(head, :events, events)
    |> Map.put(:max_balance, new_balance)
    updated_acc = acc ++ [updated_item]
    add_events_to_forecast(tail, events_list, new_balance, updated_acc)
  end

  def add_events_to_forecast([], _events_list, _balance, acc) do
    acc
  end

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

  def item_to_map(item) do
    type = case item.__struct__ do
      Samwise.Money.Income -> "income"
      Samwise.Money.Bill -> "bill"
    end
    Map.from_struct(item)
    |> Map.delete(:__meta__)
    |> Map.delete(:inserted_at)
    |> Map.delete(:updated_at)
    |> Map.delete(:id)
    |> Map.put(:type, type)
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

  def add_min_max_budgets(dates_list, budgets_daily, acc, index \\ 1)

  def add_min_max_budgets([head | tail], budgets_daily, acc, index) do
    min_balance = head.max_balance - (budgets_daily * index)
    updated_item = Map.put(head, :min_balance, min_balance)
    updated_acc = acc ++ [updated_item]
    add_min_max_budgets(tail, budgets_daily, updated_acc, index + 1)
  end

  def add_min_max_budgets([], _budgets_daily, acc, _index) do
    acc
  end

  # Get all forecast items (incomes & bills)

  def get_forecast_items do
    incomes = Samwise.Money.IncomeController.all_incomes()
    bills = Samwise.Money.BillController.all_bills()
    incomes ++ bills
  end
end
