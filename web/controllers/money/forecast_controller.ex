defmodule Samwise.Money.ForecastController do
  use Samwise.Web, :controller
  plug :add_service_nav, "_service_nav_money.html"

  def index(conn, _params) do
    bills_total = 33
    render(conn, "index.html", bills_total: bills_total, page_title: "Forecast")
  end

  def add_service_nav(conn, template) do
    assign(conn, :service_nav, template)
  end
end
