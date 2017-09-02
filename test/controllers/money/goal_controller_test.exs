defmodule Samwise.Money.GoalControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.Goal
  @valid_attrs %{
    amount: 42,
    imageUrl: "some content",
    isDebt: true,
    name: "some content",
    url: "some content",
    order: 1
  }
  @invalid_attrs %{}

  setup do
    user = insert(:user)
    [conn: assign(build_conn(), :user, user)]
  end

  test "lists all entries on index", %{conn: conn} do
    conn = conn
      |> get(goal_path(conn, :index))
    assert html_response(conn, 200) =~ "Goals"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
      |> get(goal_path(conn, :new))
    assert html_response(conn, 200) =~ "New goal"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
      |> post(goal_path(conn, :create), goal: @valid_attrs)
    assert redirected_to(conn) == goal_path(conn, :index)
    assert Repo.get_by(Goal, @valid_attrs)
  end

  test "does not create resource and errors when invalid", %{conn: conn} do
    conn = conn
      |> post(goal_path(conn, :create), goal: @invalid_attrs)
    assert html_response(conn, 200) =~ "New goal"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    goal = insert(:goal)
    conn = conn
      |> get(goal_path(conn, :edit, goal))
    assert html_response(conn, 200) =~ "Edit goal"
  end

  test "updates resource and redirects when data is valid", %{conn: conn} do
    goal = insert(:goal)
    conn = conn
      |> put(goal_path(conn, :update, goal), goal: @valid_attrs)
    assert redirected_to(conn) == goal_path(conn, :index)
    assert Repo.get_by(Goal, @valid_attrs)
  end

  test "does not update and renders errors when invalid", %{conn: conn} do
    goal = Repo.insert! %Goal{}
    conn = conn
      |> put(goal_path(conn, :update, goal), goal: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit goal"
  end

  test "deletes chosen resource", %{conn: conn} do
    goal = insert(:goal)
    conn = conn
      |> delete(goal_path(conn, :delete, goal))
    assert redirected_to(conn) == goal_path(conn, :index)
    refute Repo.get(Goal, goal.id)
  end
end
