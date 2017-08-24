defmodule Samwise.Money.IncomeControllerTest do
  use Samwise.ConnCase
  import Samwise.Plug.SetTestAuthUser

  alias Samwise.Money.Income
  @valid_attrs %{amount: 42, due: 1, name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = conn
      |> get(income_path(conn, :index))
    assert html_response(conn, 200) =~ "Incomes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
      |> get(income_path(conn, :new))
    assert html_response(conn, 200) =~ "New income"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
      |> post(income_path(conn, :create), income: @valid_attrs)
    assert redirected_to(conn) == income_path(conn, :index)
    assert Repo.get_by(Income, @valid_attrs)
  end

  test "does not create resource and errors when invalid data", %{conn: conn} do
    conn = conn
      |> post(income_path(conn, :create), income: @invalid_attrs)
    assert html_response(conn, 200) =~ "New income"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    income = Repo.insert! %Income{}
    conn = conn
      |> get(income_path(conn, :edit, income))
    assert html_response(conn, 200) =~ "Edit income"
  end

  test "updates chosen resource and redirects when valid data", %{conn: conn} do
    income = Repo.insert! %Income{}
    conn = conn
      |> put(income_path(conn, :update, income), income: @valid_attrs)
    assert redirected_to(conn) == income_path(conn, :index)
    assert Repo.get_by(Income, @valid_attrs)
  end

  test "does not update and errors when invalid data", %{conn: conn} do
    income = Repo.insert! %Income{}
    conn = conn
      |> put(income_path(conn, :update, income), income: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit income"
  end

  test "deletes chosen resource", %{conn: conn} do
    income = Repo.insert! %Income{}
    conn = conn
      |> delete(income_path(conn, :delete, income))
    assert redirected_to(conn) == income_path(conn, :index)
    refute Repo.get(Income, income.id)
  end
end
