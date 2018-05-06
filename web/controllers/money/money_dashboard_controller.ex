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
  alias Samwise.GetEvents

  def index(conn, _params) do
    render(conn,
      "index.html",
      total_available: BankAccountController.total_available(),
      available: GetEvents.get_safe_to_spend(),
      goals: GoalController.all_goals(),
      surplus: surplus(),
      page_title: "Dashboard")
  end

  def surplus do
    income_monthly = IncomeController.total() || 0
    bills_monthly = BillController.total() || 0
    budgets_monthly = BudgetController.total() || 0

    income_monthly - bills_monthly - budgets_monthly
  end
end
