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
      %{date: "2/11/1982", day: 11, items: []},
      %{date: "2/12/1982", day: 12, items: []},
      %{date: "2/13/1982", day: 13, items: []},
      %{date: "2/14/1982", day: 14, items: []},
      %{date: "2/15/1982", day: 15, items: []}
    ]
    assert Controller.get_dates_map(days_to_forecast, starting_date, []) == expected_list
  end

  test "adds items to dates list" do
    dates_list = [
      %{date: "2/11/1982", day: 11, items: []},
      %{date: "2/12/1982", day: 12, items: []},
      %{date: "2/13/1982", day: 13, items: []},
      %{date: "2/14/1982", day: 14, items: []},
      %{date: "2/15/1982", day: 15, items: []}
    ]
    items_list = [
      %Samwise.Money.Income{amount: 3500, due: 12, name: "Husk"},
      %Samwise.Money.Bill{amount: 11.99, due: 12, name: "Hulu", url: "hulu.com"},
      %Samwise.Money.Bill{amount: 10.35, due: 13, name: "XBox Gold", url: "xbox.com"}
    ]
    balance = 1000
    expected_list = [
      %{date: "2/11/1982", day: 11, items: []},
      %{date: "2/12/1982", day: 12, items: [
        %{amount: 3500, due: 12, name: "Husk", type: "income"},
        %{amount: 11.99, due: 12, name: "Hulu", url: "hulu.com", type: "bill"}
      ]},
      %{date: "2/13/1982", day: 13, items: [
        %{amount: 10.35, due: 13, name: "XBox Gold", url: "xbox.com", type: "bill"}
      ]},
      %{date: "2/14/1982", day: 14, items: []},
      %{date: "2/15/1982", day: 15, items: []}
    ]


    assert Controller.add_items_to_forecast(dates_list, items_list, balance, []) == expected_list
  end
end
