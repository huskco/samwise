defmodule Samwise.Money.ForecastController do
  use Samwise.Web, :controller
  plug :add_service_nav, "_service_nav_money.html"

  alias Samwise.Money.Forecast

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def add_service_nav(conn, template) do
    assign(conn, :service_nav, template)
  end
end
