defmodule Samwise.Money.GoalControllerTest do
  use Samwise.ConnCase

  alias Samwise.Money.Goal
  alias Samwise.Money.GoalController
  @valid_attrs %{
    name: "some content",
    amount: 42,
    imageUrl: "some content",
    isDebt: true,
    url: "some content",
    order: 1
  }
  @invalid_attrs %{}

  @goals_default [
    %{
      id: 1,
      name: "GoalName1",
      amount: 1000,
      order: 1111,
      imageUrl: nil,
      isDebt: false,
      url: "http://example.com",
      inserted_at: ~N[2018-01-01 00:00:00.000000],
      updated_at: ~N[2018-01-01 00:00:00.000000],
    },
    %{
      id: 2,
      name: "GoalName2",
      amount: 2500,
      order: 2,
      imageUrl: nil,
      isDebt: false,
      url: "http://example2.com",
      inserted_at: ~N[2018-01-01 00:00:00.000000],
      updated_at: ~N[2018-01-01 00:00:00.000000],
    },
    %{
      id: 3,
      name: "GoalName3",
      amount: 5000,
      order: 3,
      imageUrl: nil,
      isDebt: false,
      url: "http://example3.com",
      inserted_at: ~N[2018-01-01 00:00:00.000000],
      updated_at: ~N[2018-01-01 00:00:00.000000],
    }
  ]
  @goals_with_progress [
    %{
      id: 1,
      name: "GoalName1",
      amount: 1000,
      order: 1111,
      imageUrl: nil,
      isDebt: false,
      url: "http://example.com",
      inserted_at: ~N[2018-01-01 00:00:00.000000],
      updated_at: ~N[2018-01-01 00:00:00.000000],
      achieved: 1000,
      progress_percentage: 100.0
    },
    %{
      id: 2,
      name: "GoalName2",
      amount: 2500,
      order: 2,
      imageUrl: nil,
      isDebt: false,
      url: "http://example2.com",
      inserted_at: ~N[2018-01-01 00:00:00.000000],
      updated_at: ~N[2018-01-01 00:00:00.000000],
      achieved: 1250,
      progress_percentage: 50.0
    },
    %{
      id: 3,
      name: "GoalName3",
      amount: 5000,
      order: 3,
      imageUrl: nil,
      isDebt: false,
      url: "http://example3.com",
      inserted_at: ~N[2018-01-01 00:00:00.000000],
      updated_at: ~N[2018-01-01 00:00:00.000000],
      achieved: 0,
      progress_percentage: 0.0
    }
  ]
  @goals_with_dates [
    %{
      id: 1,
      name: "GoalName1",
      amount: 1000,
      order: 1111,
      imageUrl: nil,
      isDebt: false,
      url: "http://example.com",
      inserted_at: ~N[2018-01-01 00:00:00.000000],
      updated_at: ~N[2018-01-01 00:00:00.000000],
      achieved: 1000,
      progress_percentage: 100.0,
      estimated_end_date: "Jan 2018"
    },
    %{
      id: 2,
      name: "GoalName2",
      amount: 2500,
      order: 2,
      imageUrl: nil,
      isDebt: false,
      url: "http://example2.com",
      inserted_at: ~N[2018-01-01 00:00:00.000000],
      updated_at: ~N[2018-01-01 00:00:00.000000],
      achieved: 1250,
      progress_percentage: 50.0,
      estimated_end_date: "Feb 2018"
    },
    %{
      id: 3,
      name: "GoalName3",
      amount: 5000,
      order: 3,
      imageUrl: nil,
      isDebt: false,
      url: "http://example3.com",
      inserted_at: ~N[2018-01-01 00:00:00.000000],
      updated_at: ~N[2018-01-01 00:00:00.000000],
      achieved: 0,
      progress_percentage: 0.0,
      estimated_end_date: "Sep 2018"
    }
  ]

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

  test "shifts date into the past" do
    {date, remaining, surplus} = {~D[2018-01-01], -1000, 50}
    result = ~D[2017-12-12]
    assert GoalController.shift_date(date, remaining, surplus) == result
  end

  test "shifts date to the present" do
    {date, remaining, surplus} = {~D[2018-01-01], 0, 50}
    result = ~D[2018-01-01]
    assert GoalController.shift_date(date, remaining, surplus) == result
  end

  test "shifts date to the future" do
    {date, remaining, surplus} = {~D[2018-01-01], 10000, 50}
    result = ~D[2018-07-20]
    assert GoalController.shift_date(date, remaining, surplus) == result
  end

  test "adds progress" do
    results = @goals_default
      |> GoalController.add_progress(2250, [])
    assert results == @goals_with_progress
  end

  test "adds dates" do
    start_date = ~D[2018-01-01]
    results = @goals_with_progress
      |> GoalController.add_date(start_date, 25, [])
    assert results == @goals_with_dates
  end

  test "find how much of goal is achieved when more is available" do
    {available, goal_amount, expected} = {2500, 500, 500}
    assert GoalController.goal_achieved(available, goal_amount) == expected
  end

  test "find how much of goal is achieved when none is available" do
    {available, goal_amount, expected} = {0, 2000, 0}
    assert GoalController.goal_achieved(available, goal_amount) == expected
  end

  test "find how much of goal is achieved when some is available" do
    {available, goal_amount, expected} = {2000, 5000, 2000}
    assert GoalController.goal_achieved(available, goal_amount) == expected
  end
end
