defmodule Samwise.Money.ForecastController do
  use Samwise.Web, :controller
  plug :add_service_layout, "money"

  def index(conn, _params) do
    bills_total = Samwise.Money.BillController.total()
    budgets_total = Samwise.Money.BudgetController.total()
    goals_total = Samwise.Money.GoalController.total()
    incomes_total = Samwise.Money.IncomeController.total()
    balance = 10000
    events = get_forecast_items()
      |> make_several_months(4)
      |> sort_events()
      |> add_balance()

    render(conn,
      "index.html",
      bills_total: bills_total,
      budgets_total: budgets_total,
      goals_total: goals_total,
      incomes_total: incomes_total,
      events: events,
      balance: balance,
      page_title: "Forecast")
  end

  def add_service_layout(conn, service) do
    Samwise.SharedController.add_service_layout(conn, service)
  end

  def get_forecast_items do
    incomes = Samwise.Money.IncomeController.all_incomes()
    bills = Samwise.Money.BillController.all_bills()

    incomes ++ bills
  end

  def make_several_months([head | tail], months_to_add, full_events \\ []) do
    item = %{item: head, balance: 0}
    make_several_months(tail, months_to_add, full_events)
  end

  def make_several_months([], months_to_add, full_events) do
    full_events
  end

  def sort_events(events) do
    events
  end

  def add_balance(items) do
    items
  end
end
