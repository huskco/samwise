defmodule Samwise.Money.BillControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.Bill
  @valid_attrs %{
    amount: 42.00,
    due: 11,
    name: "some content",
    url: "google.com",
    autopay: false,
    is_debt: false
  }
  @invalid_attrs %{}

  setup do
    user = insert(:user)
    [conn: assign(build_conn(), :user, user)]
  end

  test "lists all entries on index", %{conn: conn} do
    conn = conn
      |> get(bill_path(conn, :index))
    assert html_response(conn, 200) =~ "Bills"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
      |> get(bill_path(conn, :new))
    assert html_response(conn, 200) =~ "New bill"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
      |> post(bill_path(conn, :create), bill: @valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :index)
    assert Repo.get_by(Bill, @valid_attrs)
  end

  test "does not create and renders errors when invalid data", %{conn: conn} do
    conn = conn
      |> post(bill_path(conn, :create), bill: @invalid_attrs)
    assert html_response(conn, 200) =~ "New bill"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bill = insert(:bill)
    conn = conn
      |> get(bill_path(conn, :edit, bill))
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "updates chosen resource and redirects when valid data", %{conn: conn} do
    bill = insert(:bill)
    conn = conn
      |> put(bill_path(conn, :update, bill), bill: @valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :index)
    assert Repo.get_by(Bill, @valid_attrs)
  end

  test "does not update and renders errors when invalid data", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = conn
      |> put(bill_path(conn, :update, bill), bill: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "deletes chosen resource", %{conn: conn} do
    bill = insert(:bill)
    conn = conn
      |> delete(bill_path(conn, :delete, bill))
    assert redirected_to(conn) == bill_path(conn, :index)
    refute Repo.get(Bill, bill.id)
  end
end
