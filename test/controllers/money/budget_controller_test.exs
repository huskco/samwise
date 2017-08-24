defmodule Samwise.Money.BudgetControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.Budget
  @valid_attrs %{amount: 42.00, name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> get(budget_path(conn, :index))
    assert html_response(conn, 200) =~ "Budgets"
  end

  test "renders form for new resources", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> get(budget_path(conn, :new))
    assert html_response(conn, 200) =~ "New budget"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> post(budget_path(conn, :create), budget: @valid_attrs)
    assert redirected_to(conn) == budget_path(conn, :index)
    assert Repo.get_by(Budget, @valid_attrs)
  end

  test "does not create and renders errors when invalid data", %{conn: conn} do
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> post(budget_path(conn, :create), budget: @invalid_attrs)
    assert html_response(conn, 200) =~ "New budget"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    budget = Repo.insert! %Budget{}
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> get(budget_path(conn, :edit, budget))
    assert html_response(conn, 200) =~ "Edit budget"
  end

  test "updates chosen resource and redirects when valid data", %{conn: conn} do
    budget = Repo.insert! %Budget{}
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> put(budget_path(conn, :update, budget), budget: @valid_attrs)
    assert redirected_to(conn) == budget_path(conn, :index)
    assert Repo.get_by(Budget, @valid_attrs)
  end

  test "does not update and renders errors when invalid data", %{conn: conn} do
    budget = Repo.insert! %Budget{}
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> put(budget_path(conn, :update, budget), budget: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit budget"
  end

  test "deletes chosen resource", %{conn: conn} do
    budget = Repo.insert! %Budget{}
    user = insert(:user)
    conn = conn
    |> assign(:user, user)
    |> delete(budget_path(conn, :delete, budget))
    assert redirected_to(conn) == budget_path(conn, :index)
    refute Repo.get(Budget, budget.id)
  end
end
