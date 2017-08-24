defmodule Samwise.Money.ForecastControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.ForecastController, as: Controller

  test "lists all entries on index", %{conn: conn} do
    Repo.insert! %Samwise.Money.BankAccount{
      balance: 1000.00,
      savings: 1500.00,
      cushion: 500.00
    }
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> get(forecast_path(conn, :index))
    assert html_response(conn, 200) =~ "Forecast"
  end

  test "makes list of forecasted dates" do
    days_to_forecast = 5
    starting_date = Timex.parse!("02/11/1982", "%m/%d/%Y", :strftime)
    expected_list = [
      %{date: "02/11/1982", day: 11, events: []},
      %{date: "02/12/1982", day: 12, events: []},
      %{date: "02/13/1982", day: 13, events: []},
      %{date: "02/14/1982", day: 14, events: []},
      %{date: "02/15/1982", day: 15, events: []}
    ]
    test_data = Controller.get_dates_map(days_to_forecast, starting_date, [])
    assert test_data == expected_list
  end

  test "adds events to dates list" do
    dates = [
      %{date: "2/11/1982", day: 11, events: []},
      %{date: "2/12/1982", day: 12, events: []},
      %{date: "2/13/1982", day: 13, events: []},
      %{date: "2/14/1982", day: 14, events: []},
      %{date: "2/15/1982", day: 15, events: []}
    ]
    events = [
      %Samwise.Money.Income{amount: 3500, due: 12, name: "Husk"},
      %Samwise.Money.Bill{
        amount: 11.99,
        due: 12,
        name: "Hulu",
        url: "hulu.com",
        autopay: false
      },
      %Samwise.Money.Bill{
        amount: 10.35,
        due: 13,
        name: "XBox Gold",
        url: "xbox.com",
        autopay: false
      }
    ]
    balance = 1000.00
    expected_list = [
      %{date: "2/11/1982", day: 11, max_balance: 1.0e3, events: []},
      %{date: "2/12/1982", day: 12, max_balance: 4488.01, events: [
        %{amount: 3500, due: 12, name: "Husk", type: "income", url: nil},
        %{amount: 11.99, due: 12, name: "Hulu", url: "hulu.com", type: "bill",
          autopay: false}
      ]},
      %{date: "2/13/1982", day: 13, max_balance: 4477.66, events: [
        %{amount: 10.35, due: 13, name: "XBox Gold", url: "xbox.com",
          type: "bill", autopay: false}
      ]},
      %{date: "2/14/1982", day: 14, max_balance: 4477.66, events: []},
      %{date: "2/15/1982", day: 15, max_balance: 4477.66, events: []}
    ]
    test_data = Controller.add_events_to_forecast(dates, events, balance, [])
    assert test_data == expected_list
  end

  test "adds minimum balance to list" do
    dates_list = [
      %{date: "2/11/1982", day: 11, max_balance: 1000, events: []},
      %{date: "2/12/1982", day: 12, max_balance: 4488.01, min_balance: 4488.01,
        events: [
          %{amount: 3500, due: 12, name: "Husk", type: "income"},
          %{amount: 11.99, due: 12, name: "Hulu", url: "hulu.com", type: "bill"}
        ]
      },
      %{date: "2/13/1982", day: 13, max_balance: 4477.66,
        events: [
          %{amount: 10.35, due: 13, name: "XBox Gold", url: "xbox.com",
            type: "bill"}
        ]
      },
      %{date: "2/14/1982", day: 14, max_balance: 4477.66, events: []},
      %{date: "2/15/1982", day: 15, max_balance: 4477.66, events: []}
    ]
    budgets_daily = 25.00
    expected_list = [
      %{date: "2/11/1982", day: 11, max_balance: 1000, min_balance: 975,
        events: []},
      %{date: "2/12/1982", day: 12, max_balance: 4488.01, min_balance: 4438.01,
        events: [
          %{amount: 3500, due: 12, name: "Husk", type: "income"},
          %{amount: 11.99, due: 12, name: "Hulu", url: "hulu.com", type: "bill"}
        ]
      },
      %{date: "2/13/1982", day: 13, max_balance: 4477.66, min_balance: 4402.66,
        events: [
          %{amount: 10.35, due: 13, name: "XBox Gold", url: "xbox.com",
            type: "bill"}
        ]
      },
      %{date: "2/14/1982", day: 14, max_balance: 4477.66, min_balance: 4377.66,
        events: []},
      %{date: "2/15/1982", day: 15, max_balance: 4477.66, min_balance: 4352.66,
        events: []}
    ]

    test_data = Controller.add_min_max_budgets(dates_list, budgets_daily, [], 1)
    assert test_data == expected_list
  end

  test "transforms events to chart data" do
    dates_list = [
      %{date: "2/11/1982", day: 11, max_balance: 1000, min_balance: 975,
        events: []},
      %{date: "2/12/1982", day: 12, max_balance: 4488.01, min_balance: 4438.01,
        events: [
          %{amount: 3500, due: 12, name: "Husk", type: "income"},
          %{amount: 11.99, due: 12, name: "Hulu", url: "hulu.com", type: "bill"}
        ]
      },
      %{date: "2/13/1982", day: 13, max_balance: 4477.66, min_balance: 4402.66,
        events: [
          %{amount: 10.35, due: 13, name: "XBox Gold", url: "xbox.com",
            type: "bill"}
        ]
      },
      %{date: "2/14/1982", day: 14, max_balance: 4477.66, min_balance: 4377.66,
        events: []},
      %{date: "2/15/1982", day: 15, max_balance: 4477.66, min_balance: 4352.66,
        events: []}
    ]

    expected_list = [
      %{
        name: "Minimum balance",
        data: [
          ["2/12/1982", 4488.01],
          ["2/13/1982", 4477.66]
        ]
      },
      %{
        name: "Maximum balance",
        data: [
          ["2/12/1982", 4438.01],
          ["2/13/1982", 4402.66]
        ]
      }]

    assert Controller.transform_to_chart_data(dates_list) == expected_list
  end
end
