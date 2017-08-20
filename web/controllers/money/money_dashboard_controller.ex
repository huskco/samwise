defmodule Samwise.Money.MoneyDashboardController do
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug :add_service_layout, "money"

  def index(conn, _params) do
    balance = Samwise.Money.BankAccountController.balance()
    available = Samwise.Money.BankAccountController.available()

    render(conn,
      "index.html",
      balance: balance,
      available: available,
      page_title: "Dashboard")
  end

  def add_service_layout(conn, service) do
    Samwise.SharedController.add_service_layout(conn, service)
  end
end
