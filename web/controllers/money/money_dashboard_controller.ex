defmodule Samwise.Money.MoneyDashboardController do
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug :add_service_layout, "money"

  def index(conn, _params) do
    render(conn,
      "index.html",
      balance: Samwise.Money.BankAccountController.balance(),
      available: Samwise.Money.ForecastController.get_available_to_spend(),
      goals: Samwise.Money.GoalController.all_goals(),
      surplus: surplus,
      page_title: "Dashboard")
  end

  def add_service_layout(conn, service) do
    Samwise.SharedController.add_service_layout(conn, service)
  end

  def surplus do
    income_monthly = Samwise.Money.IncomeController.total()
    bills_monthly = Samwise.Money.BillController.total()
    budgets_monthly = Samwise.Money.BudgetController.total()

    income_monthly - bills_monthly - budgets_monthly
  end
end
