defmodule Samwise.Money.ForecastControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.ForecastController, as: Controller

  #alias Samwise.Money.Forecast

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, forecast_path(conn, :index)
    assert html_response(conn, 200) =~ "Forecast"
  end

  test "makes list of forecasted dates" do
    days_to_forecast = 5
    starting_date = Timex.parse!("02/11/1982", "%-m/%-d/%Y", :strftime)
    expected_list = [
      %{date: ~N[1982-02-11 00:00:00], items: %{}},
      %{date: ~N[1982-02-12 00:00:00], items: %{}},
      %{date: ~N[1982-02-13 00:00:00], items: %{}},
      %{date: ~N[1982-02-14 00:00:00], items: %{}},
      %{date: ~N[1982-02-15 00:00:00], items: %{}}
    ]
    assert Controller.get_dates_map(days_to_forecast, starting_date, []) == expected_list
  end
end
