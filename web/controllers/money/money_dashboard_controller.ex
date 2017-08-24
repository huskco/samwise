defmodule Samwise.Money.MoneyDashboardController do
  @moduledoc """
    Controller for Money dashboard
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.Money.BankAccountController
  alias Samwise.Money.ForecastController
  alias Samwise.Money.GoalController
  alias Samwise.Money.IncomeController
  alias Samwise.Money.BillController
  alias Samwise.Money.BudgetController

  def index(conn, _params) do
    render(conn,
      "index.html",
      balance: BankAccountController.balance(),
      available: ForecastController.get_available_to_spend(),
      goals: GoalController.all_goals(),
      surplus: surplus(),
      page_title: "Dashboard")
  end

  def surplus do
    income_monthly = IncomeController.total()
    bills_monthly = BillController.total()
    budgets_monthly = BudgetController.total()

    income_monthly - bills_monthly - budgets_monthly
  end
end
