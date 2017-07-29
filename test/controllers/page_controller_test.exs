defmodule Samwise.PageControllerTest do
  use Samwise.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Samwise!"
  end
end
