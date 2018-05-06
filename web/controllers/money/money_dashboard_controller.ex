defmodule Samwise.Money.MoneyDashboardController do
  @moduledoc """
    Controller for Money dashboard
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.Money.BankAccountController
  alias Samwise.Money.GoalController
  alias Samwise.Money.IncomeController
  alias Samwise.Money.BillController
  alias Samwise.Money.BudgetController
  alias Samwise.Money.ForecastController
  alias Samwise.GetEvents

  def index(conn, _params) do
    render(conn,
      "index.html",
      total_available: BankAccountController.total_available(),
      available: GetEvents.get_safe_to_spend(),
      goals: GoalController.all_goals(),
      surplus: surplus(),
      bank_accounts: BankAccountController.all_dashboard_accounts(),
      investment_accounts: BankAccountController.all_investment_accounts(),
      allowance_accounts: BankAccountController.all_allowance_accounts(),
      monthly_income: IncomeController.total(),
      monthly_debt: BillController.debt_total() || 0,
      page_title: "Dashboard")
  end

  def surplus do
    income_monthly = IncomeController.total() || 0
    bills_monthly = BillController.total() || 0
    budgets_monthly = BudgetController.total() || 0

    income_monthly - bills_monthly - budgets_monthly
  end
end
