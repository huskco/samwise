defmodule Samwise.Money.ForecastController do
  use Samwise.Web, :controller
  plug :add_service_layout, "money"

  def index(conn, _params) do
    bills_total = Samwise.Money.BillController.total()
    budgets_total = Samwise.Money.BudgetController.total()
    goals_total = Samwise.Money.GoalController.total()
    incomes_total = Samwise.Money.IncomeController.total()
    balance = 10000
    days_to_forecast = 120
    table_events = get_forecast_items()
    chart_events = get_dates_map(days_to_forecast, Timex.today, [])
      |> add_items_to_forecast(get_forecast_items())
      #|> add_balance()

    render(conn,
      "index.html",
      bills_total: bills_total,
      budgets_total: budgets_total,
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

  def get_dates_map(days_to_forecast, date, dates_list \\ [])

  def get_dates_map(days_to_forecast, date, dates_list) when days_to_forecast > 0 do
    next_date = Timex.shift(date, days: 1)
    item = %{date: date, items: %{}}
    get_dates_map(days_to_forecast - 1, next_date, [item | dates_list])
  end

  def get_dates_map(days_to_forecast, _date, dates_list) when days_to_forecast == 0 do
    Enum.reverse(dates_list)
  end

  def add_items_to_forecast(dates_list, [head | tail], itemized_list \\ [])

  def add_items_to_forecast(dates_list, [head | tail], itemized_list) do
    add_items_to_forecast(dates_list, tail, itemized_list)
  end

  def add_items_to_forecast(dates_list, [], itemized_list) do
    itemized_list
  end

  def get_forecast_items do
    incomes = Samwise.Money.IncomeController.all_incomes()
    bills = Samwise.Money.BillController.all_bills()
    incomes ++ bills
  end
end
