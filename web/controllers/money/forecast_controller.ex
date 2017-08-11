defmodule Samwise.Money.ForecastController do
  use Samwise.Web, :controller
  plug :add_service_layout, "money"

  def index(conn, _params) do
    bills_total = Samwise.Money.BillController.total()
    budgets_total = Samwise.Money.BudgetController.total()
    budgets_daily = budgets_total / 30
    goals_total = Samwise.Money.GoalController.total()
    incomes_total = Samwise.Money.IncomeController.total()
    balance = 10000
    days_to_forecast = 120
    table_events = get_forecast_items()
    chart_events = get_dates_map(days_to_forecast, Timex.today, [])
      |> add_items_to_forecast(get_forecast_items(), balance, [])
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
    item = %{date: Samwise.NextDate.simple_date(date), day: date.day, items: []}
    get_dates_map(days_to_forecast - 1, next_date, [item | dates_list])
  end

  def get_dates_map(days_to_forecast, _date, dates_list) when days_to_forecast == 0 do
    Enum.reverse(dates_list)
  end

  # Add items to Forecast

  def add_items_to_forecast([head | tail], items_list, balance, acc) do
    items = items_on_day(items_list, head.day, [])
    new_balance = balance_after_items(items, balance)
    updated_item = Map.put(head, :items, items)
    |> Map.put(:max_balance, new_balance)
    updated_acc = acc ++ [updated_item]
    add_items_to_forecast(tail, items_list, new_balance, updated_acc)
  end

  def add_items_to_forecast([], _items_list, _balance, acc) do
    acc
  end

  def items_on_day([head | tail], day, acc) do
    updated_acc = case head.due == day do
      true -> acc ++ [item_to_map(head)]
      false -> acc
    end

    items_on_day(tail, day, updated_acc)
  end

  def items_on_day([], _day, acc) do
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

  def balance_after_items([head | tail], balance) do
    new_balance = case head.type do
      "income" -> balance + head.amount
      "bill" -> balance - head.amount
    end

    balance_after_items(tail, new_balance)
  end

  def balance_after_items([], balance) do
    balance
  end

  # Add min & max budgets to forecast list

  def add_min_max_budgets([head | tail], budgets_daily, acc, index \\ 1) do
    min_balance = head.max_balance - (budgets_daily * index)
    updated_item = Map.put(head, :min_balance, min_balance)
    updated_acc = acc ++ [updated_item]
    add_min_max_budgets(tail, budgets_daily, updated_acc, index + 1)
  end

  def add_min_max_budgets([], _budgets_daily, acc, index) do
    acc
  end

  # Get all forecast items (incomes & bills)

  def get_forecast_items do
    incomes = Samwise.Money.IncomeController.all_incomes()
    bills = Samwise.Money.BillController.all_bills()
    incomes ++ bills
  end
end
