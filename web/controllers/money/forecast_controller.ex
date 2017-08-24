defmodule Samwise.Money.ForecastController do
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.Money.Bill
  alias Samwise.Money.Income
  alias Samwise.Money.BillController
  alias Samwise.Money.BudgetController
  alias Samwise.Money.IncomeController
  alias Samwise.Money.BankAccountController
  alias Samwise.NextDate

  def index(conn, _params) do
    budgets_daily = BudgetController.daily_average()
    balance = BankAccountController.balance()
    events = get_events()
    available_to_spend = get_available_to_spend()

    events_chart_data = events
      |> transform_to_chart_data
      |> Poison.encode!

    render(conn,
      "index.html",
      budgets_daily: budgets_daily,
      events: events,
      eventsChartData: events_chart_data,
      balance: balance,
      available_to_spend: available_to_spend,
      page_title: "Forecast")
  end

  def get_events do
    days_to_forecast = 90
    start_date = Timex.today
    items = get_forecast_items()
    balance = BankAccountController.balance()
    budgets_daily = BudgetController.daily_average()
    get_events(days_to_forecast, start_date, items, balance, budgets_daily)
  end

  def get_events(days_to_forecast, start_date, forecast_items, balance, budgets_daily) do
    days_to_forecast
      |> get_dates_map(start_date, [])
      |> add_events_to_forecast(forecast_items, balance, [])
      |> add_min_max_budgets(budgets_daily, [])
  end

  def get_available_to_spend do
    get_available_to_spend(get_events())
  end

  def get_available_to_spend([head | tail]) do
    get_available_to_spend(tail, head.min_balance)
  end

  def get_available_to_spend([head | tail], smallest) do
    case smallest > head.min_balance do
      true -> get_available_to_spend(tail, head.min_balance)
      false -> get_available_to_spend(tail, smallest)
    end
  end

  def get_available_to_spend([], smallest) do
    smallest - cushion()
  end

  # Build list of dates for N days

  def get_dates_map(days_to_forecast, date, dates_list \\ [])

  def get_dates_map(days_to_forecast, date, dates_list) when days_to_forecast > 0 do
    next_date = Timex.shift(date, days: 1)
    item = %{date: NextDate.simple_date(date), day: date.day, events: []}
    get_dates_map(days_to_forecast - 1, next_date, [item | dates_list])
  end

  def get_dates_map(days_to_forecast, _date, dates_list) when days_to_forecast == 0 do
    Enum.reverse(dates_list)
  end

  # Add events to Forecast

  def add_events_to_forecast([head | tail], events_list, balance, acc) do
    events = events_on_day(events_list, head.day, [])
    new_balance = balance_after_events(events, balance)
    updated_item = head
      |> Map.put(:events, events)
      |> Map.put(:max_balance, new_balance)
    updated_acc = acc ++ [updated_item]
    add_events_to_forecast(tail, events_list, new_balance, updated_acc)
  end

  def add_events_to_forecast([], _events_list, _balance, acc) do
    acc
  end

  def events_on_day([head | tail], day, acc) do
    updated_acc = case head.due == day do
      true -> acc ++ [item_to_map(head)]
      false -> acc
    end

    events_on_day(tail, day, updated_acc)
  end

  def events_on_day([], _day, acc) do
    acc
  end

  def item_to_map(item) do
    type = case item.__struct__ do
      Income -> "income"
      Bill -> "bill"
    end
    url = case item.__struct__ do
      Income -> nil
      Bill -> item.url
    end
    item
      |> Map.from_struct()
      |> Map.delete(:__meta__)
      |> Map.delete(:inserted_at)
      |> Map.delete(:updated_at)
      |> Map.delete(:id)
      |> Map.put(:type, type)
      |> Map.put(:url, url)
  end

  def balance_after_events([head | tail], balance) do
    new_balance = case head.type do
      "income" -> balance + head.amount
      "bill" -> balance - head.amount
    end

    balance_after_events(tail, new_balance)
  end

  def balance_after_events([], balance) do
    balance
  end

  # Add min & max budgets to forecast list

  def add_min_max_budgets(dates_list, budgets_daily, acc, index \\ 1)

  def add_min_max_budgets([head | tail], budgets_daily, acc, index) do
    min_balance = head.max_balance - (budgets_daily * index)
    updated_item = Map.put(head, :min_balance, min_balance)
    updated_acc = acc ++ [updated_item]
    add_min_max_budgets(tail, budgets_daily, updated_acc, index + 1)
  end

  def add_min_max_budgets([], _budgets_daily, acc, _index) do
    acc
  end

  # Transform all that into something the chart can digest

  def transform_to_chart_data(events) do
    transform_to_chart_data(events, [], [])
  end

  def transform_to_chart_data([head | tail], min_acc, max_acc) do
    updated_min_acc = case head.events != [] do
      true -> min_acc ++ [[head.date, head.min_balance]]
      false -> min_acc
    end

    updated_max_acc = case head.events != [] do
      true -> max_acc ++ [[head.date, head.max_balance]]
      false -> max_acc
    end

    transform_to_chart_data(tail, updated_min_acc, updated_max_acc)
  end

  def transform_to_chart_data([], min_acc, max_acc) do
    [%{
      name: "Minimum balance",
      data: max_acc
    },
    %{
      name: "Maximum balance",
      data: min_acc
    }]
  end

  # Get all forecast items (incomes & bills)

  def get_forecast_items do
    incomes = IncomeController.all_incomes()
    bills = BillController.all_bills()
    incomes ++ bills
  end

  def cushion do
    BankAccountController.cushion()
  end
end
