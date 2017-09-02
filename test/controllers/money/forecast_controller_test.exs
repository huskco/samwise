defmodule Samwise.Money.ForecastControllerTest do
  use Samwise.ConnCase

  setup do
    user = insert(:user)
    [conn: assign(build_conn(), :user, user)]
  end

  test "lists all entries on index", %{conn: conn} do
    Repo.insert! %Samwise.Money.BankAccount{
      balance: 1000.00,
      savings: 1500.00,
      cushion: 500.00
    }
    conn = conn |> get(forecast_path(conn, :index))
    assert html_response(conn, 200) =~ "Forecast"
  end
end
