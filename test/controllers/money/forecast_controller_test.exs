defmodule Samwise.Money.ForecastControllerTest do
  use Samwise.ConnCase

  setup do
    user = insert(:user)
    [conn: assign(build_conn(), :user, user)]
  end

  test "lists all entries on index", %{conn: conn} do
    conn = conn |> get(forecast_path(conn, :index))
    assert html_response(conn, 200) =~ "Forecast"
  end
end
