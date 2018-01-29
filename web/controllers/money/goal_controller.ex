defmodule Samwise.Money.GoalController do
  @moduledoc """
    Controller for Money Goal
  """
  use Samwise.Web, :controller
  plug Samwise.Plugs.RequireAuth
  plug Samwise.Plugs.AddServiceLayout, "money"

  alias Samwise.SmartDate
  alias Samwise.GetEvents
  alias Samwise.Money.Goal
  alias Samwise.Money.MoneyDashboardController

  def index(conn, _params) do
    goals = all_goals()
    render(conn,
      "index.html",
      goals: goals,
      total: total(),
      page_title: "Goals"
    )
  end

  def new(conn, _params) do
    changeset = Goal.changeset(%Goal{})
    render(conn, "new.html", changeset: changeset, page_title: "New Goal")
  end

  def create(conn, %{"goal" => goal_params}) do
    changeset = Goal.changeset(%Goal{}, goal_params)

    case Repo.insert(changeset) do
      {:ok, _goal} ->
        conn
        |> put_flash(:info, "Goal created successfully.")
        |> redirect(to: goal_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    goal = Repo.get!(Goal, id)
    changeset = Goal.changeset(goal)
    render(conn,
      "edit.html",
      goal: goal,
      changeset: changeset,
      page_title: "Edit #{goal.name}"
    )
  end

  def update(conn, %{"id" => id, "goal" => goal_params}) do
    goal = Repo.get!(Goal, id)
    changeset = Goal.changeset(goal, goal_params)

    case Repo.update(changeset) do
      {:ok, _goal} ->
        conn
        |> put_flash(:info, "Goal updated successfully.")
        |> redirect(to: goal_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", goal: goal, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    goal = Repo.get!(Goal, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(goal)

    conn
    |> put_flash(:info, "Goal deleted successfully.")
    |> redirect(to: goal_path(conn, :index))
  end

  def all_goals do
    Goal
      |> order_by(asc: :order)
      |> order_by(desc: :amount)
      |> Repo.all
      |> add_progress
      |> add_date
  end

  def total do
    Repo.one(from g in Goal, select: sum(g.amount))
  end

  def add_progress(goals) do
    available_to_spend = GetEvents.get_available_to_spend()
    add_progress(goals, available_to_spend, [])
  end

  def add_progress([head | tail], available_to_spend, acc) do
    goal_achieved = goal_achieved(available_to_spend, head.amount)
    progress_percentage = case head.amount != 0 do
      true -> round(goal_achieved / head.amount * 100)
      false -> 100
    end
    updated_available_to_spend = available_to_spend - goal_achieved

    updated_item = head
      |> Map.put(:achieved, goal_achieved)
      |> Map.put(:progress_percentage, progress_percentage)
    updated_acc = acc ++ [updated_item]
    add_progress(tail, updated_available_to_spend, updated_acc)
  end

  def add_progress([], _, acc) do
    acc
  end

  def add_date(goals) do
    date = Timex.today
    daily_surplus = MoneyDashboardController.surplus() / 30
    add_date(goals, date, daily_surplus, [])
  end

  def add_date([head|tail], date, daily_surplus, acc) do
    remaining = head.amount - head.achieved
    shifted_date = shift_date(date, remaining, daily_surplus)
    pretty_date = SmartDate.pretty_date(shifted_date, :month)
    updated_item = Map.put(head, :estimated_end_date, pretty_date)
    updated_acc = acc ++ [updated_item]

    add_date(tail, shifted_date, daily_surplus, updated_acc)
  end

  def add_date([], _, _, acc) do
    acc
  end

  def shift_date(date, remaining, surplus) do
    days_to_shift = round(remaining / surplus)
    shifted_date = Timex.shift(date, days: days_to_shift)
    shifted_date
  end

  def goal_achieved(available_to_spend, goal_amount) do
    cond do
      available_to_spend > goal_amount -> goal_amount
      available_to_spend < 0 -> 0
      true -> available_to_spend
    end
  end
end
