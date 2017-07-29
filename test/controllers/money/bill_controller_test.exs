defmodule Samwise.Money.BillControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.Bill
  @valid_attrs %{amount: 42, due: 42, name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, bill_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing bills"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, bill_path(conn, :new)
    assert html_response(conn, 200) =~ "New bill"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, bill_path(conn, :create), bill: @valid_attrs
    assert redirected_to(conn) == bill_path(conn, :index)
    assert Repo.get_by(Bill, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, bill_path(conn, :create), bill: @invalid_attrs
    assert html_response(conn, 200) =~ "New bill"
  end

  test "shows chosen resource", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = get conn, bill_path(conn, :show, bill)
    assert html_response(conn, 200) =~ "Show bill"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, bill_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = get conn, bill_path(conn, :edit, bill)
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = put conn, bill_path(conn, :update, bill), bill: @valid_attrs
    assert redirected_to(conn) == bill_path(conn, :show, bill)
    assert Repo.get_by(Bill, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = put conn, bill_path(conn, :update, bill), bill: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "deletes chosen resource", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = delete conn, bill_path(conn, :delete, bill)
    assert redirected_to(conn) == bill_path(conn, :index)
    refute Repo.get(Bill, bill.id)
  end
end
