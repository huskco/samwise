defmodule Samwise.Money.ForecastController do
  @moduledoc """
    Controller for Money Forecast
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.Money.BudgetController
  alias Samwise.Money.BankAccountController
  alias Samwise.GetEvents

  def index(conn, _params) do
    budgets_daily = BudgetController.daily_average()
    total_available = BankAccountController.total_available()
    events = GetEvents.all()
    safe_to_spend = GetEvents.get_safe_to_spend()

    events_chart_data = events
      |> GetEvents.transform_to_chart_data
      |> Poison.encode!
    render(conn,
      "index.html",
      budgets_daily: budgets_daily,
      events: events,
      eventsChartData: events_chart_data,
      total_available: total_available,
      safe_to_spend: safe_to_spend,
      page_title: "Forecast")
  end
end
