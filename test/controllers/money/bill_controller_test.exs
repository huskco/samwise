defmodule Samwise.Money.BillControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.Bill
  @valid_attrs %{amount: 42.00, due: 11, name: "some content", url: "google.com", autopay: false}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> get(bill_path(conn, :index))
    assert html_response(conn, 200) =~ "Bills"
  end

  test "renders form for new resources", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> get(bill_path(conn, :new))
    assert html_response(conn, 200) =~ "New bill"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> post(bill_path(conn, :create), bill: @valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :index)
    assert Repo.get_by(Bill, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> post(bill_path(conn, :create), bill: @invalid_attrs)
    assert html_response(conn, 200) =~ "New bill"
  end

  test "shows chosen resource", %{conn: conn} do
    bill = Repo.insert! %Bill{name: "Bill", url: "google.com", due: 5, amount: 10.00}
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> get(bill_path(conn, :show, bill))
    assert html_response(conn, 200) =~ bill.name
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      user = insert(:user)
      conn
      |> assign(:user, user)
      |> get(bill_path(conn, :show, -1))
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> get(bill_path(conn, :edit, bill))
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> put(bill_path(conn, :update, bill), bill: @valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :show, bill)
    assert Repo.get_by(Bill, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> put(bill_path(conn, :update, bill), bill: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "deletes chosen resource", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> delete(bill_path(conn, :delete, bill))
    assert redirected_to(conn) == bill_path(conn, :index)
    refute Repo.get(Bill, bill.id)
  end
end
