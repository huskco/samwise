defmodule Samwise.Money.IncomeControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.Income
  @valid_attrs %{amount: 42, dates: [], name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, income_path(conn, :index)
    assert html_response(conn, 200) =~ "Incomes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, income_path(conn, :new)
    assert html_response(conn, 200) =~ "New income"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, income_path(conn, :create), income: @valid_attrs
    assert redirected_to(conn) == income_path(conn, :index)
    assert Repo.get_by(Income, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, income_path(conn, :create), income: @invalid_attrs
    assert html_response(conn, 200) =~ "New income"
  end

  test "shows chosen resource", %{conn: conn} do
    income = Repo.insert! %Income{}
    conn = get conn, income_path(conn, :show, income)
    assert html_response(conn, 200) =~ "Show income"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, income_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    income = Repo.insert! %Income{}
    conn = get conn, income_path(conn, :edit, income)
    assert html_response(conn, 200) =~ "Edit income"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    income = Repo.insert! %Income{}
    conn = put conn, income_path(conn, :update, income), income: @valid_attrs
    assert redirected_to(conn) == income_path(conn, :show, income)
    assert Repo.get_by(Income, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    income = Repo.insert! %Income{}
    conn = put conn, income_path(conn, :update, income), income: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit income"
  end

  test "deletes chosen resource", %{conn: conn} do
    income = Repo.insert! %Income{}
    conn = delete conn, income_path(conn, :delete, income)
    assert redirected_to(conn) == income_path(conn, :index)
    refute Repo.get(Income, income.id)
  end
end
