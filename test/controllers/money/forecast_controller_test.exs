defmodule Samwise.Money.ForecastControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.Forecast
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, forecast_path(conn, :index)
    assert html_response(conn, 200) =~ "Forecast"
  end
end
