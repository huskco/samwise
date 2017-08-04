defmodule Samwise.Money.ForecastController do
  use Samwise.Web, :controller
  plug :add_service_layout, "money"

  def index(conn, _params) do
    bills_total = Samwise.Money.BillController.total()
    budgets_total = Samwise.Money.BudgetController.total()
    goals_total = Samwise.Money.GoalController.total()
    incomes_total = Samwise.Money.IncomeController.total()
    render(conn,
      "index.html",
      bills_total: bills_total,
      budgets_total: budgets_total,
      goals_total: goals_total,
      incomes_total: incomes_total,
      page_title: "Forecast")
  end

  def add_service_layout(conn, service) do
    Samwise.SharedController.add_service_layout(conn, service)
  end
end
