defmodule Samwise.Money.MoneyDashboardController do
  use Samwise.Web, :controller
  plug :add_service_layout, "money"

  def index(conn, _params) do
    bills_total = Samwise.Money.BillController.total()
    budgets_total = Samwise.Money.BudgetController.total()
    budgets_daily = Samwise.Money.BudgetController.daily_average()
    goals_total = Samwise.Money.GoalController.total()
    incomes_total = Samwise.Money.IncomeController.total()
    balance = 12000

    render(conn,
      "index.html",
      bills_total: bills_total,
      budgets_total: budgets_total,
      budgets_daily: budgets_daily,
      goals_total: goals_total,
      incomes_total: incomes_total,
      balance: balance,
      page_title: "Dashboard")
  end

  def add_service_layout(conn, service) do
    Samwise.SharedController.add_service_layout(conn, service)
  end
end
